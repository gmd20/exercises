#!/bin/bash
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -e "s/\r//g" -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# eval $(parse_yaml example_config.yml "config_")
# access yaml content
#echo $config_development_database

YAML_CONFIG_FILE="example_config.yml"
if [[ -n $1 ]]; then
	if [[ $1 == *.yml ]] && [[ -e $1 ]]; then
		YAML_CONFIG_FILE=$1
	else
		echo "$1 file doesn't exit"
	fi
fi
echo "generate example_config.xml from template and $YAML_CONFIG_FILE."

# parse_yaml "$YAML_CONFIG_FILE" ""
eval $(parse_yaml "$YAML_CONFIG_FILE" "")








ADDRESS_MAP=""
ADDR_COMMENT="\\
                            <!--\\
                            @)\\
                            -->"

# split string into array, delimiter is , and space
IFS=', ' read -r -a ADDRESS_ARRAY <<< "$CONNECTION_IP"

# access string array
for index in "${!ADDRESS_ARRAY[@]}"
do
	address_map_id=$(($index +1))
	gt_number="${ADDRESS_ARRAY[index]}"

  # when sed replacement regexp includes a newline, be sure to precede the
  # desired \, &, or newline in the replacement with a \.
	AddressMap="\\
                        <AddressMap id=\"${address_map_id}\">${ADDR_COMMENT}\\
                          <OutAddr ip=\"${AS_local_pc}\"\/>\\
                        <\/AddressMap>"
	ADDRESS_MAP+="$AddressMap"
	OUR_ADDR_COMMENT=""
done
#echo "${ADDRESS_MAP}"




sed \
  -e "s|{{ADDRESS_MAP}}|$ADDRESS_MAP|g" \
  -e "s/{{development_database}}/$development_database/g" \
  -e "s/{{development_text1}}/$development_text1/g" \
  < example_config.xml.template \
  > example_config.xml
  
  
  
