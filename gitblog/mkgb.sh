#!/bin/bash 

file=
author="Magelive"
mdate=`date "+%Y-%m-%d"`
title=""
tags=""
category=`basename ${PWD}`
mstatus="publish"
summary=""
images=""
head=""
TMPFILE=.tmp.md

usage()
{
	echo "usage: $0 [opt] [params] ...";
	echo "			-f|--file: 需要处理的markdown文件";
	echo "			-a|--author: 博客作者名称";
	echo "			-d|--date : 博客时间，用于页面显示，通常来说你不需要填写这个字段，默认就是创建日期";
	echo "			-t|--title: 博客标题"
	echo "			-l|--tags: 博客里的标签，多个用逗号或空格分隔"
	echo "			-c|--category: 博客分类，多个用逗号或空格分隔"
	echo "			-s|--status: 博客状态，\`draft\`表示草稿，GitBlog解析时会忽略草稿；\`publish\`表示发表状态，默认为publish"
	echo "			-b|--summary: 博客摘要信息"
	echo "			-i|--images:博客的图片集，这里可以定义博客用到的图片的地址"
	echo "			-e|--head: 作者的头像地址"
	echo "			-h|--help : 帮助信息"
}

eval set -- `getopt -o f:a:d:t:l:c:s:b:i:e:h -al file:,author:,date:,title:,tags:,category:,status:,summary:,images:,head:,help -- "$@"`
while [ -n $1 ]
do
	case "$1" in
		-f|--file) 
			file=$2;shift 2;;
		-a|--author) 
			author=$2;shift 2;;
		-d|--date)
			mdate=$2;shift 2;;
		-t|--title)
			title=$2;shift 2;;
		-l|--tags)
			tags=$2;shift 2;;
		-c|--category)
			category=$2;shift 2;;
		-s|--status)
			mstatus=$2;shift 2;;
		-b|--summary)
			summary=$2;shift 2;;
		-i|--images)
			images=$2;shift 2;;
		-e|--head)
			head=$2;shift 2;;
		-h|--help)
			usage;exit 0;;
		--)
			break;;
	esac
done

if [ -z $file ] 
then
	echo "must has file."
	exit 0
else
	if [ -f $file ];then
		cat $file > $TMPFILE
	fi
fi

echo "<!--" > $file
echo "author: $author" >>$file
echo "date: $mdate" >>$file
echo "title: $title" >>$file
echo "tags: $tags" >>$file
echo "category: $category" >>$file
echo "status: $mstatus" >>$file
echo "summary: $summary" >>$file

if [ -n $head ]; then
	echo "head: $head" >>$file
fi

if [ -n $images ]; then
	echo "images: $images" >>$file
fi

echo "--!>" >> $file

echo >>$file

if [ -f $TMPFILE ] 
then
	cat $TMPFILE >>$file
	rm -f $TMPFILE
fi


