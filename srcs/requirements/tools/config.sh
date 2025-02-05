echo "==== INCEPTION CONFIGURATION ===="

printf "\nEnter the path where to create your mariadb database and wordpress files"
printf "\nExemple: /home/donghank/data\n"
read path

if [ ! -d "$path" ]; then
	echo "This repo doesn't exist, please create it"
	exit 1
fi

echo $path > srcs/requirements/tools/data_path.txt

cp srcs/requirements/tool/template_compose.yml srcs/docker-compose.yml

cat srcs/docker-compose.yml | sed "s+pathtodata+$path+g" > srcs/docker-compose.yml.tmp
mv srcs/docker-compose.yml.tmp srcs/docker-compose.yml
