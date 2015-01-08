// 编译:
//   cl.exe lrc_to_srt.cpp
// 使用：
//  lrc_to_srt.exe  01en.lrc 01zh.lrc > 01.srt

#include <string.h>
#include <stdio.h>
#include <string>
#include <vector>
#include <algorithm>

struct LrcLine
{
  int  millisecond; // 显示本行歌词时间 相对文件最开始的偏移，毫秒
  std::string   content;     // 要显示的一行内容
};
bool operator< (LrcLine &l, LrcLine &r)
{
  return l.millisecond < r.millisecond;
}

typedef std::vector<LrcLine>  LrcData;

/////////////////////////////////////////////////////////////
// 因为 有的lrc 文件时间标签不按顺序排列，
// 就可能出现歌词显示不正常，此函数的功能就是
// 把时间标签对应的歌词排好序，
////////////////////////////////////////////////////////////
void sort_lrc_data(LrcData  &lrc_data)
{
  std::sort(lrc_data.begin(), lrc_data.end());
}

//////////////////////////////////////
// 把有相同显示时间的合并为一项
///////////////////////////////////////
void trim_lrc_data(LrcData &lrc_data)
{
  unsigned int i = 0;
  while (i + 1 < lrc_data.size()) {
    if (lrc_data[i].millisecond == lrc_data[i+1].millisecond) {
      if (lrc_data[i].content != lrc_data[i+1].content) {
        // lrc 歌词应该是不支持换行的，这里只是为了srt格式里面显示
        lrc_data[i].content += "\n";
        lrc_data[i].content += lrc_data[i+1].content;
      }
      lrc_data.erase(lrc_data.begin() + i + 1);
    }
    i++;
  }
}

//////////////////////////////////////////////////////////////////////////////
// 函数: bool Load_lrc_file(char * filename)
//
// 目的: 加载lrc 文件。
//
// 返回 1表示成功，返回2表示文件格式有错误，不能正确处理。返回0表示文件打不开。
//  加载 时间标签格式包含分、秒和毫秒
// 例如;其中一部分为
// [ti:玩美]
// [ar:蔡依林]
// [al:舞娘]
// [by:rodick]
// [03:21.78][02:37.30][00:01.06]01.玩美
// [03:25.81][02:41.03][00:06.56]www.51lrc.com ★ rodick 制作
// [00:15.84]
// [00:24.20]时尚重生 用完美定义女人
// [00:28.12]耀眼的灵魂 在谁的躯体里封存
// [00:33.19]光彩缤纷 惊艳了所有眼神
// /[00:37.48]懂爱的人 才能够得到一个吻
///////////////////////////////////////////////////////////////////////////////

bool load_lrc_file(const char * lrc_filename, LrcData  &lrc_data)
{

	FILE * lrc_file = fopen(lrc_filename,"r");
	if (lrc_file == NULL) {
		return false;
	}

	int read_items = 0;        // fscanf 成功读取进来的变量数
	int minute;  double second; // 时间标签 [  ] 中的分钟，秒
	char content[512];         // 歌词内容缓存
  double offset = 0;          // 歌词整体时间偏移

  while (read_items != EOF) {
		int num_time_label = 0;  // 同一行中时间标签的数量
		while(1) {
      // 此循环处理多个时间标签放置在同一行的情况，
      // 比如 [03:19.14][01:14.45][00:01.15]03.马德里不思议
			read_items = fscanf(lrc_file, "[%d:%lf]", &minute, &second);
			if (read_items == 2) {  //正确读入了一个时间标签
        LrcLine line;
        line.millisecond = static_cast<int>((minute*60 + second)*1000 - offset);
        lrc_data.push_back(line);
        num_time_label++;
      } else {
        break;
			}
		}

		if (num_time_label == 0) {  // 成功读入的时间标签一个都没有
      // 尝试读入offset时间偏移
      // 格式示例
      // [ti:香水有毒]
      // [ar:胡杨林]
      // [al:香水有毒(宣传单曲)]
      // [by:郁闷]
      // [offset:500]
      // [00:04.00]胡杨林 - 香水有毒
      // "offset:%lf] " 最后的空格可以匹配换行符和空格。如果offset标签同一行后面
      // 还有内容就把他当作新的一行来处理
      read_items = fscanf(lrc_file,"offset:%lf] ", &offset);
      if (read_items == 1)  {
        continue;
      }

      // 尝试读取标题
      // [ti:BBC《步入商界》01：自我介绍]
      read_items = fscanf(lrc_file,"ti:%500[^]] ", &content);
      if (read_items == 1)  {
        LrcLine  line;
        line.millisecond = 0;   // 把标题作为最开始的显示内容
        line.content = content;
        lrc_data.push_back(line);
        continue;
      }

      // 没有读入一个 offset标签,忽略本行内容，转到下一行继续处理,
      read_items = fscanf(lrc_file,"%500[^\r\n] ", content);
      continue;
		}

    read_items = fscanf(lrc_file,"%500[^\r\n] ", content);  //读入本行歌词内容
    if (read_items == 1) {
      for (;num_time_label > 0; num_time_label--) {
        lrc_data[lrc_data.size() - num_time_label].content = content;
      }
    } else {
      // 处理如下面所示的段落行（没有歌词数据，但是有一个回车换行符，
      // 要处理一下这个回车符，才能读进下一行）
      // [01:07.77]我带着爱抒情的远行
      // [01:12.74]
      // [01:19.46]火红的舞衣旋转在绿荫小径
      // 在scanf函数的format格式里，一个空白符可以代表0到多个空格，指表符\t，
      // 回车符\n
      for (;num_time_label > 0; num_time_label--) {
        // 插入一个空内容，这个不能省略，不然“我带着爱抒情的远行”这句歌词会
        // 一直显示到 "[01:19.46]火红的舞衣旋转在绿荫小径”
        lrc_data[lrc_data.size() - num_time_label].content = "    ";
      }
      // 用空格匹配换行符，本行没有歌词数据，只是歌词表示段落
      read_items = fscanf(lrc_file, "  ");
    }
	}

	fclose(lrc_file);

  sort_lrc_data(lrc_data);
  trim_lrc_data(lrc_data);
	return true;
}

////////////////////////////////////////////////////////////////////////////
// 把两个lrc 文件合并在一起，主要用于一个中文字幕文件，一个英文字幕文件，
// 同样的时间翻译合并到一起，然后转成视频文件的srt 字幕文件
// 两个文件要事先排好序. 合并的结果存在于第一个 lrc_data 里面
////////////////////////////////////////////////////////////////////////
void merge_lrc_data(LrcData &lrc_data, LrcData & lrc_data_2)
{
  unsigned int size = lrc_data.size();
  unsigned int i = 0;
  while (i < lrc_data.size()) {
    if (lrc_data[i].millisecond == lrc_data_2[i].millisecond) {
      if (lrc_data[i].content != lrc_data_2[i].content) {
        // lrc 歌词应该是不支持换行的，这里只是为了srt格式里面显示
        lrc_data[i].content += "\n";
        lrc_data[i].content += lrc_data_2[i].content;
      }
    } else {
      lrc_data.push_back(lrc_data_2[i]);
    }
    i++;
  }

  sort_lrc_data(lrc_data);
  unsigned int new_size = lrc_data.size();
  if (size != new_size) {
    printf("两个lrc文件合并时可能出错了，合并的两个文件时间格式要完全一致才行。 size = %d, new_size = %d\n", size, new_size);
  }
}

void format_srt_time(char *output, int millisecond)
{
  int milli = millisecond % 1000;
  int secs = millisecond / 1000;
  int mins = secs / 60;
      secs = secs % 60;
  sprintf(output, "00:%0.2d:%02d,%0.3d",
                   mins, secs, milli);
}

// srt 文件格式
// 11
// 00:01:46,630 --> 00:01:48,540
// 非常好，谢谢您！

// 12
// 00:01:48,590 --> 00:01:50,370
// 今天早上很冷。
// bool save_lrc_as_srt(const char *src_file_name, LrcData &lrc_data)
bool save_lrc_as_srt(LrcData &lrc_data)
{
	// FILE * srt_file = fopen(src_file_name,"w+");
	// if (srt_file == NULL) {
	//	return false;
	// }

  char time1[64];
  char time2[64];

  for (unsigned int i = 0; i < lrc_data.size(); i++) {
    int t1 = lrc_data[i].millisecond;
    int t2 = t1;
    if (i + 1 < lrc_data.size()) {
      int t3 = lrc_data[i+1].millisecond - 50;
      if (t3 - t1 > 50) { t2 = t3; }
    }
    format_srt_time(time1, t1);
    format_srt_time(time2, t2);

    printf(
    // fprintf(srt_file,
            "%d\n"
            "%s --> %s\n"
            "%s\n\n",
             i +1,
             time1, time2,
             lrc_data[i].content.c_str());
  }

	// fclose(srt_file);
	return true;
}

int main(int argc,char *argv[])
{
  if (argc == 2) {
    LrcData lrc_data;
    load_lrc_file(argv[1], lrc_data);
    save_lrc_as_srt(lrc_data);
  } else if (argc == 3) {
    LrcData lrc_data;
    LrcData lrc_data_2;
    load_lrc_file(argv[1], lrc_data);
    load_lrc_file(argv[2], lrc_data_2);
    merge_lrc_data(lrc_data, lrc_data_2);
    save_lrc_as_srt(lrc_data);
  } else {
    printf("把lrc歌词文件转成srt视频字幕文件\n"
          "可以合并时间格式一致的两个中英文字幕文件。\n"
          "例子: lrc_to_srt.exe  01en.lrc 01zh.lrc > 01.srt\n"
          "usage:  %s <lrc_file> [lrc_file_2]\n",
           argv[0]);
    return 1;
  }
  return 0;
}
