#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

// Aho-Corasick (AC) 自动机 多关键字匹配
// AC自动机 是多模式匹配的黄金标准。 它的时间复杂度是 O(文本长度 + 匹配数 + 模式串长度)

// --- 配置参数 ---
#define MAX_KEYWORDS 100
#define MAX_KEYWORD_LEN 16

// 支持的可显示 ASCII 范围: 45 ('-') 到 122 ('z')
// 总共 95 个字符
#define CHAR_START 45
#define CHAR_END 122
#define ALPHABET_SIZE (CHAR_END - CHAR_START + 1)

// 计算最大节点数：所有关键字长度之和 + 1 (Root节点)
// 预留一些余量
#define MAX_NODES (MAX_KEYWORDS * MAX_KEYWORD_LEN + 10)

// --- 数据结构 ---

typedef struct TrieNode {
    // 使用 uint16_t 索引代替指针，-1 表示空
    int16_t next[ALPHABET_SIZE];
    int16_t fail;                // fail 节点的索引
    int16_t output;              // 关键字索引，-1 表示非结尾
} TrieNode;

// 静态内存池
TrieNode pool[MAX_NODES];
int node_count = 0;

// 全局统计
int keyword_counts[MAX_KEYWORDS];
char *keywords[MAX_KEYWORDS];
int keyword_count = 0;

// --- 初始化与工具函数 ---

// 初始化一个节点
void init_node(int idx) {
    // 将 next 数组全部置为 -1
    memset(pool[idx].next, -1, sizeof(pool[idx].next));
    pool[idx].fail = 0;
    pool[idx].output = -1;
}

void ac_init() {
    node_count = 0;
    init_node(0); // pool[0] 是 Root 节点
    // 这里 node_count 不需要 +1，因为 0 已经被 Root 占用了
    // 后续新节点从 node_count + 1 开始分配

    for (int i = 0; i < MAX_KEYWORDS; i++) {
        keyword_counts[i] = 0;
    }
}

// 获取字符对应的数组索引，如果不在可显示范围内返回 -1
inline int get_char_idx(unsigned char c) {
    if (c < CHAR_START || c > CHAR_END) {
        return -1;
    }
    return c - CHAR_START;
}

// 插入关键字
void ac_insert(const char *word, int index) {
    int current = 0; // Root 索引
    for (int i = 0; word[i] != '\0'; i++) {
        int char_idx = get_char_idx((unsigned char)word[i]);
        if (char_idx == -1) {
            // 如果关键字包含不可显示字符，跳过（或者报错，视需求而定）
            continue;
        }

        if (pool[current].next[char_idx] == -1) {
            // 分配新节点
            int new_node = node_count + 1;
            if (new_node >= MAX_NODES) {
                fprintf(stderr, "Error: Node pool exhausted\n");
                exit(1);
            }
            pool[current].next[char_idx] = new_node;
            init_node(new_node);
            node_count = new_node;
        }
        current = pool[current].next[char_idx];
    }
    pool[current].output = index;
}

// 构建 Fail 指针
void ac_build() {
    // 简单的队列，存储节点索引
    int queue[MAX_NODES];
    int head = 0, tail = 0;

    // 第一层：Fail 指向 Root (0)
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        int child_idx = pool[0].next[i];
        if (child_idx != -1) {
            pool[child_idx].fail = 0;
            queue[tail++] = child_idx;
        }
    }

    // BFS 构建
    while (head < tail) {
        int current = queue[head++];
        for (int i = 0; i < ALPHABET_SIZE; i++) {
            int child = pool[current].next[i];
            if (child != -1) {
                int fail = pool[current].fail;

                // 寻找 child 的 fail 节点
                // 只要 fail 不是 root，且 fail 没有对应字符的边，就继续跳 fail
                while (fail != 0 && pool[fail].next[i] == -1) {
                    fail = pool[fail].fail;
                }

                if (pool[fail].next[i] != -1) {
                    pool[child].fail = pool[fail].next[i];
                } else {
                    pool[child].fail = 0;
                }
                queue[tail++] = child;
            }
        }
    }
}

// 搜索
void ac_search(const char *text, size_t len) {
    int current = 0;
    for (size_t i = 0; i < len; i++) {
        int char_idx = get_char_idx((unsigned char)text[i]);

        // 如果字符不可显示，直接重置状态到 Root
        // 因为我们的关键字里只有可显示字符
        if (char_idx == -1) {
            current = 0;
            continue;
        }

        // 如果没有对应的边，跳转到 fail 节点
        while (current != 0 && pool[current].next[char_idx] == -1) {
            current = pool[current].fail;
        }

        if (pool[current].next[char_idx] != -1) {
            current = pool[current].next[char_idx];
        }

        // 检查匹配结果（包括沿 fail 链向上的结果）
        int temp = current;
        while (temp != 0) {
            if (pool[temp].output != -1) {
                keyword_counts[pool[temp].output]++;
                // 如果需要统计重叠出现，不 break
                // 如果只需要统计该位置出现，break 取决于需求
                // 这里我们统计所有出现，包括子串匹配
            }
            temp = pool[temp].fail;
        }
    }
}

// --- 主函数 ---

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <url_file>\n", argv[0]);
        return 1;
    }

    // 1. 配置关键字 (假设查找这三个)
    keywords[0] = "google";
    keywords[1] = "baidu";
    keywords[2] = "github";
    keyword_count = 3;

    printf("Initializing AC Automaton (Static Pool Mode)...\n");
    printf("Alphabet Size: %d, Max Nodes: %d\n", ALPHABET_SIZE, MAX_NODES);

    // 2. 构建自动机
    ac_init();
    for (int i = 0; i < keyword_count; i++) {
        ac_insert(keywords[i], i);
    }
    ac_build();

    // 3. 打开文件
    const char *filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }

    struct stat sb;
    if (fstat(fd, &sb) == -1) {
        perror("Error getting file size");
        close(fd);
        return 1;
    }
    size_t file_size = sb.st_size;

    char *file_data = (char *)mmap(NULL, file_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (file_data == MAP_FAILED) {
        perror("Error mmapping the file");
        close(fd);
        return 1;
    }

    // 4. 搜索
    printf("Scanning %zu bytes...\n", file_size);
    ac_search(file_data, file_size);

    // 5. 结果
    printf("\n--- Results ---\n");
    for (int i = 0; i < keyword_count; i++) {
        printf("Keyword '%s': %d occurrences\n", keywords[i], keyword_counts[i]);
    }

    // 6. 清理
    munmap(file_data, file_size);
    close(fd);

    return 0;
}
