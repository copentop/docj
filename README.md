### 前端docker开发环境


### 目录结构

	./nginx
		./nginx.congf 	nginx 基础配置文件
		./certs			证书目录

		./nginx_vhosts	nginx 多域名配置目录，约定一个文件一个项目
			demo.com.conf 	demo.com 项目
			


	./projects 		项目的workspace根目录，约定一个子目录一个项目
		./demo.com 	实例项目


	./hosts			hosts 文件，多域名修改，同时需要在本地hosts也要修改

	Dockerfile		docker 镜像生成文件


### nginx 服务目录
	
	安装目录：
	/usr/local/nginx

	约定nginx服务根放置的目录，不同项目可以在根目录下创建子目录。
	/var/www/

### docker 构建命令

	docker build -t docj:v1 .

	# docj:v1 为 构建镜像的tag，docker run 命令依赖这个tag


### docker 启动命令

	如果本地没有web服务，可以使用端口 -p 80:80 , 如果有web服务，需要修改端口，例如 -p 8080:80 。

	本地目录和容器映射需要绝对路径，需要修改source的值

	docker run -it -d -p 8090:80  --mount type=bind,source=F:/docker-workp/docj/projects,target=/var/www --mount type=bind,source=F:/docker-workp/docj/nginx,target=/usr/local/nginx/conf/ --mount type=bind,source=F:/docker-workp/docj/hosts/hosts,target=/etc/hosts --name web_serv1 docj:v1 