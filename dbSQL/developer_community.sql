/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50710
Source Host           : localhost:3306
Source Database       : developer_community

Target Server Type    : MYSQL
Target Server Version : 50710
File Encoding         : 65001

Date: 2018-05-31 13:46:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `article`
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `articleID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT 'no title',
  `date` datetime NOT NULL,
  `content` mediumtext NOT NULL,
  `favors` smallint(6) DEFAULT '0',
  `subject` varchar(255) DEFAULT 'default',
  `tags` varchar(255) DEFAULT '',
  `pv` int(11) DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `cover` longtext,
  PRIMARY KEY (`articleID`),
  KEY `userArticle` (`userID`),
  KEY `articleID` (`articleID`),
  CONSTRAINT `article_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('1', '1', '热门 nodejs中gbk转码为utf8，以exec(\'dir\')为例', '2018-04-24 23:22:44', '<div id=\\\"zoom\\\" class=\\\"logtext animated2 bounceInUp\\\"> <p>最近从Linux换为Windows，因此开始需要考虑gbk转码的问题。</p><h3>nodejs中转码需要注意三个问题：</h3><ol class=\\\" list-paddingleft-2\\\" style=\\\"list-style-type: decimal;\\\"><li><p>读取时不能使用默认utf8转码，需使用二进制即 `binary`编码</p></li><li><p>采用iconv-lite模块实际转码</p></li><li><p><span style=\\\"color: rgb(255, 0, 0);\\\">转换为其他编码之前需要使用原编码解码成功方可！！！</span><br></p></li></ol><h3>安装iconv-lite:</h3><p class=\\\"brush:js;toolbar:false\\\">npmiiconv-lite-S</pre><h3>以exec(\'dir\')为例<br></h3><p class=\\\"brush:js;toolbar:false\\\">//引入http,iconv-lite和exec模块consthttp=require(\'http\');consticonv=require(\'iconv-lite\');const{exec}=require(\'child_process\');http.createServer(function(request,response){&bsp;//执行dir命令病设置编码为二进制编码binaryexec(\'dir\',{encoding:\'binary\'},function(error,stdout,stderr){//处理结果，转码为utf8//第一步：获取buffer，设为const避免误修改constbufferReaded=Buffer.from(stdout,\'binary\');//第二步：根据原来的编码gbk解码letstrGbk=iconv.decode(bufferReaded,\'gbk\');//第三步：转为utf8bufferconststrUTF8Buffer=iconv.encode(strGbk,\'utf8\');//第四步：转为utf8字符串//多种方法：//iconv.decode(strBuf,\'utf8\')或者toString(\'utf8\')letstrUTF8=iconv.decode(strUTF8Buffer,\'utf8\');//toString()方法//letstrUTF8=strUTF8Buffer.toString(\'utf8\');response.writeHead(200,{\'Content-Type\':\'text/plain;charset=utf8\'});//输出转换完成信息response.end(strUTF8);//实际上可以直接在这里输出utf8编码的buffer，http会自动转换利用toString转换，默认编码为utf8//response.end(strUTF8Buffer);});}).listen(9527,()=&gt;{console.log(\'服务器地址为：http://127.0.0.1:9527\');});</p><h3>临时修改终端编码的方法</h3><p>配置成utf8编码：</p><p class=\\\"brush:ps;toolbar:false\\\">chcp65001</p><p>将终端换成UTF-8代码页，配置后cmd命令的输出就是utf8编码，无需再转码了。</p><p><br></p><p>恢复GBK编码:</p><p class=\\\"brush:ps;toolbar:false\\\">chcp936</p><p>有任何好方法欢迎交流~</p> <div class=\\\"blank\\\"></div> </div>', '2', '前端', 'nodejs,转码', '53', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('2', '2', 'hhh<script>console.log(\'XSS\')</SCRIPT>hhh', '2018-04-25 10:58:25', '<div class=\"b-content-word col-lg-12 col-md-12 col-xs-12\"><div class=js-content><p>关于我把 word 和 pdf 来回整的故事；<br>我有一段血泪史；<br>惊天地；泣鬼神；痛彻心扉；穿越前世今生；<br>今天我准备熬夜把它控诉一遍；<p>之前有一些愚蠢的人类给了伟大的程序猿一份 word 文档；<br>里面就一段文字；<br>需求是能动态的替换其中的部分内容；<br>然后转成 pdf 供用户下载；<p>这简单啊；<br>还要啥 word 文档啊；<br>直接手动把内容复制出来；<br>放好占位符用 php 的字符串替换函数动态替换下；<br>然后使用 <a href=https://github.com/tecnickcom/tcpdf target=_blank>tcpdf</a> ;<br>生成 pdf so easy ；<br>根本不用点读机；<br>我写过文章可以参考 <a href=https://baijunyao.com/article/73 target=_blank>thinkphp整合系列之tcpdf类生成pdf文件</a><p>然鹅需求如某某；<br>她总是善变的；<br>希望能有点样式加点图片；<br>说起样式图片我们都知道前端是擅长的；<br>我们可以先用 HTML+CSS 排好版了；<br>整个页面作为一个字符串替换其中的占位符即可；<br>然后用 <a href=https://github.com/dompdf/dompdf target=_blank>dompdf</a> 把 HTML 转成 PDF；<br>虽然曲折麻烦了点；<br>但是实现起来也不算难；<p>可万万没想到；<br>她不但善变还需求不满；<br>希望有页眉页脚页数<br>图片样式间隔；<br>而且一搞就来10几页的 word 文档；<br>而且还要经常换各种花样；<br>而且要生成的 pdf 要跟 word 源文档要保持一致到像素级别；<br>显然想像之前那样纯依赖 php 就完成是有点吃力了；<br>那么下面就有请 LibreOffice 上场了；<br>现在我们开始正文；<br>思路是这样的；<br>我们用 php 来编辑替换 word 文档内容；<br>然后调用 LibreOffice 把 word 替换成 pdf 文档；<p>用 php 编辑替换 word 就比较简单了；<br>扩展包在这 <a href=https://github.com/PHPOffice/PHPWord target=_blank>PHPWord</a>；<br>按 <a href=http://phpword.readthedocs.io/en/latest/templates-processing.html target=_blank>文档</a>很容易使用；<br>这里简单写两句；<br>在 word 源文件中占位符要包裹在 <code>${}</code> 中；<br>比如说在 source.docx 中是这样的;<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>${name}博客666<span class=line-numbers-rows aria-hidden=true><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>php 调用 setValue 方法第一个参数传 name 第二个参数传值就可以替换了；<pre class=\"code-toolbar line-numbers language-php\"><code class=language-php><span class=\"token keyword\">use</span> <span class=\"token package\">PhpOffice<span class=\"token punctuation\"></span>PhpWord<span class=\"token punctuation\"></span>TemplateProcessor</span><span class=\"token punctuation\">;</span>	<span class=\"token variable\">$phpWord</span> <span class=\"token operator\">=</span> <span class=\"token keyword\">new</span> <span class=\"token class-name\">TemplateProcessor</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'source.docx\\\'</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span>	<span class=\"token variable\">$phpWord</span><span class=\"token operator\">-</span><span class=\"token operator\">></span><span class=\"token function\">setValue</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'name\\\'</span><span class=\"token punctuation\">,</span> <span class=\"token string\">\\\'白俊遥\\\'</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span>	<span class=\"token variable\">$phpWord</span><span class=\"token operator\">-</span><span class=\"token operator\">></span><span class=\"token function\">saveAs</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'new.docx\\\'</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span><span class=line-numbers-rows aria-hidden=true><span></span><span></span><span></span><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>PHP</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>new.docx 文件中就被替换成 <code>白俊遥博客666</code>了；<p>重点要来了；<br>LibreOffice 折腾起来就稍微麻烦且有坑了；<br>先下载软件和语言包；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>cd /usr/local	wget http://download.documentfoundation.org/libreoffice/stable/5.2.7/rpm/x86_64/LibreOffice_5.2.7_Linux_x86-64_rpm.tar.gz	wget http://download.documentfoundation.org/libreoffice/stable/5.2.7/rpm/x86_64/LibreOffice_5.2.7_Linux_x86-64_rpm_langpack_zh-CN.tar.gz	wget http://download.documentfoundation.org/libreoffice/stable/5.2.7/rpm/x86_64/LibreOffice_5.2.7_Linux_x86-64_rpm_helppack_zh-CN.tar.gz<span class=line-numbers-rows aria-hidden=true><span></span><span></span><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>如果用 wget 速度几k到几十k不等/s 的话；<br>那推荐用迅雷下载到本地；在传到服务器的 /usr/local 目录；<br>把下载的这几个文件批量解压了；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>ls LibreOffice_5.2.7_Linux_x86-64_rpm* | xargs -n1 tar -zxvf<span class=line-numbers-rows aria-hidden=true><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>依次安装；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>sudo yum -y install ./LibreOffice_5.2.7.2_Linux_x86-64_rpm/RPMS/*.rpm	sudo yum -y install ./LibreOffice_5.2.7.2_Linux_x86-64_rpm_langpack_zh-CN/RPMS/*.rpm	sudo yum -y install ./LibreOffice_5.2.7.2_Linux_x86-64_rpm_helppack_zh-CN/RPMS/*.rpm<span class=line-numbers-rows aria-hidden=true><span></span><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>安装成功后到 /opt/libreoffice5.2 目录下载 unoconv；<br>这是一个用来方便调用命令把 word 转成 pdf 的工具；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>cd /opt/libreoffice5.2	wget https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv<span class=line-numbers-rows aria-hidden=true><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>给予权限并链接；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>chmod +x unoconv	sudo ln -s /opt/libreoffice5.2/unoconv /usr/bin/unoconv<span class=line-numbers-rows aria-hidden=true><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>这个时候虽然说已经可以转换了；<br>但是中文是会乱码的；<br>创建字体文件目录；<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>mkdir /usr/share/fonts/Windows<span class=line-numbers-rows aria-hidden=true><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>然后把 C:WindowsFonts 中的所有字体上传到 /usr/share/fonts/Windows<br>给予权限并刷新;<pre class=\"language-bash code-toolbar line-numbers\"><code class=language-bash>sudo chmod -R 755 Windows	sudo fc-cache -fv<span class=line-numbers-rows aria-hidden=true><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>Bash</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>再来个转换的函数；<pre class=\"code-toolbar line-numbers language-php\"><code class=language-php><span class=\"token keyword\">if</span> <span class=\"token punctuation\">(</span><span class=\"token operator\">!</span> <span class=\"token function\">function_exists</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'word_to_pdf\\\'</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">{</span>	<span class=\"token comment\">/**	* 把word转pdf	*	* @param $wordPath	* @param $pdfPath	* @return string	*/</span>	<span class=\"token keyword\">function</span> <span class=\"token function\">word_to_pdf</span><span class=\"token punctuation\">(</span><span class=\"token variable\">$wordPath</span><span class=\"token punctuation\">,</span> <span class=\"token variable\">$pdfPath</span><span class=\"token punctuation\">)</span>	<span class=\"token punctuation\">{</span>	<span class=\"token function\">set_time_limit</span><span class=\"token punctuation\">(</span><span class=\"token number\">0</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span>	<span class=\"token function\">putenv</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'HOME=/home/apache/\\\'</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span>	<span class=\"token comment\">// 生成pdf文件</span>	<span class=\"token function\">shell_exec</span><span class=\"token punctuation\">(</span><span class=\"token string\">\\\'/usr/bin/unoconv -f pdf -o \\\'</span> <span class=\"token punctuation\">.</span> <span class=\"token variable\">$pdfPath</span> <span class=\"token punctuation\">.</span> <span class=\"token string\">\\\' \\\'</span> <span class=\"token punctuation\">.</span> <span class=\"token variable\">$wordPath</span><span class=\"token punctuation\">)</span><span class=\"token punctuation\">;</span>	<span class=\"token punctuation\">}</span>	<span class=\"token punctuation\">}</span><span class=line-numbers-rows aria-hidden=true><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span></span></code><div class=toolbar><div class=toolbar-item><span>PHP</span></div><div class=toolbar-item><a>Copy</a></div></div></pre><p>最后需要注意的是如果是使用的是 nginx ；<br>php-fpm 的 user 不要是 nobody；<br>一般是 nginx 或者 www；<br>如果没有如期生成 pdf 文件；<br>使用 su nginx 或者 su www 后要手动执行 shell_exec 中的命令；<br>根据错误提示解决；<br><img alt=\"\"src=/uploads/article/20180325/5ab7aaf894623.jpeg></div><eq name=\"article[\\\'current\\\'][\\\'is_original\\\']\"value=1><p class=b-h-20><p class=b-copyright>本文为白俊遥原创文章,转载无需和我联系,但请注明来自 <a href=http://baijunyao.com>白俊遥博客</a>https://baijunyao.com 欢迎捐赠赞赏加入组织 <a href=https://baijunyao.com/article/124>创建QQ群及捐赠渠道</a></p></eq><ul class=b-prev-next><li class=b-prev>上一篇： <a href=https://baijunyao.com/article/146>linux查看nginx、apache、php、php-fpm、mysql及配置项所在目录</a><li class=b-next>下一篇： <a href=https://baijunyao.com/article/144>laravel使用腾讯企业邮箱发邮件报错501</a></ul></div>', '1', '前端', '', '31', '/static/images/test1.jpg', null);
INSERT INTO `article` VALUES ('4', '2', '三角形的 N 种画法与浏览器的开放世界', '2018-04-25 10:58:25', '4444444444', '0', '前端', '', '102', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('5', '2', '《HelloGitHub》第 25 期', '2018-04-25 10:58:25', '55555555555555555', '0', '工具资源', ' ', '37', null, null);
INSERT INTO `article` VALUES ('8', '2', '一起撸个简单粗暴的Tv应用主界面的网格布局控件（上）', '2018-04-25 10:58:25', '888888888888888', '1', '后端', '', '57', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('11', '4', '并发编程之死锁解析', '2018-04-25 10:58:25', '111111111111111111111', '10', '后端', '', '11', null, null);
INSERT INTO `article` VALUES ('12', '5', 'Spring统一返回Json工具类，带分页信息', '2018-04-25 17:37:34', '1222222222222222222', '13', '后端', '', '1', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('13', '2', 'iOS开发·runtime原理与实践: 消息转发篇(Message Forwarding) (类，对象，方法，消息传递，消息转发)', '2018-05-02 17:11:26', 'iOS开发·runtime原理与实践: 消息转发篇(Message Forwarding) (类，对象，方法，消息传递，消息转发)iOS开发·runtime原理与实践: 消息转发篇(Message Forwarding) (类，对象，方法，消息传递，消息转发)iOS开发·runtime原理与实践: 消息转发篇(Message Forwarding) (类，对象，方法，消息传递，消息转发)', '2', 'iOS', '', '20', null, null);
INSERT INTO `article` VALUES ('14', '6', 'Masonry 源码解读（上）', '2018-05-02 17:12:15', 'Masonry 源码解读（上）Masonry 源码解读（上）Masonry 源码解读（上）', '6', 'iOS', '', '300', null, null);
INSERT INTO `article` VALUES ('15', '2', '通过实现一个TableView来理解iOS UI编程', '2018-05-02 17:13:33', '通过实现一个TableView来理解iOS UI编程通过实现一个TableView来理解iOS UI编程通过实现一个TableView来理解iOS UI编程', '1', 'iOS', '', '4500', null, null);
INSERT INTO `article` VALUES ('16', '3', 'iOS新闻类App内容页技术探索', '2018-05-02 17:13:58', 'iOS新闻类App内容页技术探索iOS新闻类App内容页技术探索iOS新闻类App内容页技术探索', '66', 'iOS', '', '2', null, null);
INSERT INTO `article` VALUES ('17', '8', 'iOS底层原理总结 - RunLoop', '2018-05-02 17:14:18', 'iOS底层原理总结 - RunLoopiOS底层原理总结 - RunLoopiOS底层原理总结 - RunLoop', '56', 'iOS', '', '46', null, null);
INSERT INTO `article` VALUES ('18', '2', '如何正确的使用你的时间', '2018-05-02 17:14:44', '如何正确的使用你的时间如何正确的使用你的时间如何正确的使用你的时间', '44', '阅读', '', '35', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('20', '1', 'Hexo 个人博客 SEO 优化（3）：改造你的博客，提升搜索引擎排名', '2018-05-02 17:15:40', 'Hexo 个人博客 SEO 优化（3）：改造你的博客，提升搜索引擎排名Hexo 个人博客 SEO 优化（3）：改造你的博客，提升搜索引擎排名Hexo 个人博客 SEO 优化（3）：改造你的博客，提升搜索引擎排名', '58', '阅读', '', '106', null, null);
INSERT INTO `article` VALUES ('21', '2', '如何写一手漂亮的模型：面向对象编程的设计原则综述', '2018-05-02 17:16:25', '如何写一手漂亮的模型：面向对象编程的设计原则综述如何写一手漂亮的模型：面向对象编程的设计原则综述如何写一手漂亮的模型：面向对象编程的设计原则综述', '88', '人工智能', '', '11', null, null);
INSERT INTO `article` VALUES ('22', '2', '基于TensorFlow Lite的人声识别在端上的实现', '2018-05-02 17:16:55', '基于TensorFlow Lite的人声识别在端上的实现基于TensorFlow Lite的人声识别在端上的实现基于TensorFlow Lite的人声识别在端上的实现', '68', '人工智能', '', '25', null, null);
INSERT INTO `article` VALUES ('23', '1', '水师提督速成指南：用Keras打造你的AI水军', '2018-05-02 17:17:11', '水师提督速成指南：用Keras打造你的AI水军水师提督速成指南：用Keras打造你的AI水军水师提督速成指南：用Keras打造你的AI水军水师提督速成指南：用Keras打造你的AI水军', '41', '人工智能', '', '22', null, null);
INSERT INTO `article` VALUES ('24', '2', '英伟达AI：修图软件千千万，效果最牛的还是我这款', '2018-05-02 17:17:30', '英伟达AI：修图软件千千万，效果最牛的还是我这款英伟达AI：修图软件千千万，效果最牛的还是我这款英伟达AI：修图软件千千万，效果最牛的还是我这款', '44', '人工智能', '', '35', null, null);
INSERT INTO `article` VALUES ('25', '3', '面试了8家公司，他们问了我这些机器学习题目......', '2018-05-02 17:18:00', '面试了8家公司，他们问了我这些机器学习题目......', '88', '人工智能', '', '55', null, null);
INSERT INTO `article` VALUES ('26', '2', '几道高级前端面试题解析', '2018-05-02 17:18:47', '几道高级前端面试题解析', '89', '前端', '', '57', null, null);
INSERT INTO `article` VALUES ('28', '2', 'Android 屏幕适配方案', '2018-05-02 17:22:21', 'Android 屏幕适配方案Android 屏幕适配方案Android 屏幕适配方案', '155', 'Android', '', '73', null, null);
INSERT INTO `article` VALUES ('29', '4', 'Android 知识体系脑图「android篇」', '2018-05-02 17:22:52', 'Android 知识体系脑图「android篇」', '20', 'Android', '', '47', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('30', '2', 'Android开发中阴影效果的实现', '2018-05-02 17:23:09', 'Android开发中阴影效果的实现Android开发中阴影效果的实现Android开发中阴影效果的实现', '120', 'Android', '', '92', null, null);
INSERT INTO `article` VALUES ('31', '1', 'Android新兴扫码框架：XCodeScanner', '2018-05-02 17:23:26', 'Android新兴扫码框架：XCodeScannerAndroid新兴扫码框架：XCodeScannerAndroid新兴扫码框架：XCodeScanner', '59', 'Android', '', '53', null, null);
INSERT INTO `article` VALUES ('32', '2', '魔镜魔镜快告诉我，谁才是最酷的设计趋势？', '2018-05-02 17:23:55', '魔镜魔镜快告诉我，谁才是最酷的设计趋势？魔镜魔镜快告诉我，谁才是最酷的设计趋势？魔镜魔镜快告诉我，谁才是最酷的设计趋势？', '65', '设计', '', '455', null, null);
INSERT INTO `article` VALUES ('33', '5', '好的设计师，差的设计师', '2018-05-02 17:24:16', '好的设计师，差的设计师好的设计师，差的设计师好的设计师，差的设计师', '45', '设计', '', '21', null, null);
INSERT INTO `article` VALUES ('34', '2', 'App可靠性设计', '2018-05-02 17:24:40', 'App可靠性设计App可靠性设计App可靠性设计', '449', '设计', '', '453', null, null);
INSERT INTO `article` VALUES ('35', '2', '科技与UX中的人文科学', '2018-05-02 17:24:57', '科技与UX中的人文科学科技与UX中的人文科学科技与UX中的人文科学', '12', '设计', '', '422', null, null);
INSERT INTO `article` VALUES ('36', '1', '2018年度最佳网页设计与开发教程', '2018-05-02 17:25:23', '2018年度最佳网页设计与开发教程2018年度最佳网页设计与开发教程2018年度最佳网页设计与开发教程', '45', '设计', '', '53', null, null);
INSERT INTO `article` VALUES ('37', '2', 'GitHub Pages 对自定义的域名支持 HTTPS', '2018-05-02 17:25:55', 'GitHub Pages 对自定义的域名支持 HTTPSGitHub Pages 对自定义的域名支持 HTTPSGitHub Pages 对自定义的域名支持 HTTPS', '86', '工具资源', '', '86', null, null);
INSERT INTO `article` VALUES ('38', '8', '10 款 Linux 平台上最好的 LaTeX 编辑器', '2018-05-02 17:26:18', '10 款 Linux 平台上最好的 LaTeX 编辑器', '21', '工具资源', '', '65', null, null);
INSERT INTO `article` VALUES ('39', '2', '狂拽酷炫的terminal，你值得拥有', '2018-05-02 17:26:57', '狂拽酷炫的terminal，你值得拥有', '68', '工具资源', '', '54', null, null);
INSERT INTO `article` VALUES ('40', '1', '推荐几款超好用的Android Stuido插件', '2018-05-02 17:27:17', '推荐几款超好用的Android Stuido插件推荐几款超好用的Android Stuido插件推荐几款超好用的Android Stuido插件', '76', '工具资源', '', '78', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('41', '9', 'hexo使用jenkins自动部署到阿里云', '2018-05-02 17:27:31', 'hexo使用jenkins自动部署到阿里云hexo使用jenkins自动部署到阿里云hexo使用jenkins自动部署到阿里云', '67', '工具资源', '', '64', null, null);
INSERT INTO `article` VALUES ('42', '1', '小程序直播连麦的技术实现与解析', '2018-05-03 15:31:30', '小程序直播连麦的技术实现与解析小程序直播连麦的技术实现与解析小程序直播连麦的技术实现与解析', '67', '产品', '', '45', null, null);
INSERT INTO `article` VALUES ('43', '3', '关于微信公众号运营你要知道的24件小事', '2018-05-02 17:29:51', '关于微信公众号运营你要知道的24件小事关于微信公众号运营你要知道的24件小事关于微信公众号运营你要知道的24件小事', '58', '产品', '', '69', null, null);
INSERT INTO `article` VALUES ('44', '10', '后台产品设计（三）如何测试', '2018-05-02 17:30:06', '后台产品设计（三）如何测试后台产品设计（三）如何测试后台产品设计（三）如何测试', '49', '产品', '', '66', null, null);
INSERT INTO `article` VALUES ('45', '1', '小册晓梦轻寒\n基于 Python 进行 App 服务器端开发\n购买人数: 455\n特价: 19.9元\n分享\n', '2018-05-02 17:30:21', '小册晓梦轻寒\n基于 Python 进行 App 服务器端开发\n购买人数: 455\n特价: 19.9元\n分享\n小册晓梦轻寒\n基于 Python 进行 App 服务器端开发\n购买人数: 455\n特价: 19.9元\n分享\n小册晓梦轻寒\n基于 Python 进行 App 服务器端开发\n购买人数: 455\n特价: 19.9元\n分享\n', '89', '产品', '', '59', null, null);
INSERT INTO `article` VALUES ('46', '8', '一个 APP 的诞生 ( 笔记 + 方法论 )', '2018-05-02 17:30:38', '一个 APP 的诞生 ( 笔记 + 方法论 )一个 APP 的诞生 ( 笔记 + 方法论 )一个 APP 的诞生 ( 笔记 + 方法论 )', '89', '产品', '', '14', '/static/images/logo.png', null);
INSERT INTO `article` VALUES ('48', '1', '优化transform在过渡效果中出现文字模糊和抖动问题', '2018-05-13 23:12:14', '<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">因为transform变换会在浏览器上单独创建一个绘画层并重新进行渲染，rotate渲染的时候，由于图层渲染的时候也处理了周围的文字，如果高度为奇数的文字可能会存在半个像素的计算量，浏览器对这半个像素会进行优化渲染，所以边缘会出现模糊的情况。</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">\r\n		<span class=\"ql-cursor\">﻿</span>优化方法：&nbsp;</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">1. 将</span>\r\n	<code style=\"color: rgb(199, 37, 78); background-color: rgb(249, 242, 244);\">transform: translate(-50%, -50%)</code>\r\n	<span style=\"color: rgb(79, 79, 79);\">改成</span>\r\n	<code style=\"color: rgb(199, 37, 78); background-color: rgb(249, 242, 244);\">transform: translate3d(-50%, -50%, 0)</code>\r\n	<span style=\"color: rgb(79, 79, 79);\">可以解决抖动，但仍然模糊。&nbsp;</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">2. 将元素的高度设置为偶数可解决；&nbsp;</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">3. 将</span>\r\n	<code style=\"color: rgb(199, 37, 78); background-color: rgb(249, 242, 244);\">transform: translate(-50%, -50%)</code>\r\n	<span style=\"color: rgb(79, 79, 79);\">中的y轴单位改成px也可以解决&nbsp;</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">4. 改成</span>\r\n	<code style=\"color: rgb(199, 37, 78); background-color: rgb(249, 242, 244);\">transform: translate(-50%, -52%)</code>\r\n	<span style=\"color: rgb(79, 79, 79);\">也可以解决（如果52%不行则从51%每个百分比尝试）&nbsp;</span>\r\n</p>\r\n<p>\r\n	<span style=\"color: rgb(79, 79, 79);\">以上方法能较大程度优化问题，但仔细查看仍有细微抖动，最后用了第四种方法。</span>\r\n</p>', '1', '前端', 'transform,字体模糊,抖动', '33', null, null);
INSERT INTO `article` VALUES ('49', '1', '主流浏览器图片反防盗链方法总结', '2018-05-13 23:16:54', '<h1><strong>前言</strong></h1><p>还记得之前写的那个无聊的<a href=\"https://github.com/mythsman/hexo-douban\" target=\"_blank\" style=\"color: rgb(0, 153, 204);\">插件</a>，前一段时间由于豆瓣读书增加了防盗链策略使得我们无法直接引用他们的图片，使得我这个小插件无法工作。本以为是一个很简单的问题，但是没想到这个小问题硬是让我改了五六遍才改好，可以说是非常的蠢了。总结一下自己犯傻的原因，还是由于自己懒得去深入研究，谷歌百度了问题就直接把方案拿来用了，浅尝辄止人云亦云，解决了表面的问题而没有深入的总结。当然，从另外一个方面讲，我也是初步领会到了前端程序员面对要兼容各种浏览器的需求时头有多大了。</p><h1><strong>问题</strong></h1><p>问题很简单，就是我希望在自己的页面里用<code style=\"color: transparent;\"><img src=\"http://web.jobbole.com/94410/xxxx\"></code>来引用其他网站的一张图片，但是他的网站设置了防盗链的策略，会在后台判断请求的<code>Referrer</code>属性是不是来自于一个非本域名的网站，如果来源不是本域名就返回<code>403 forbidden</code>。我的目的就是用最方便的方法使得我的页面能够不受他的防盗链策略的影响。</p><h1><strong>解决方案</strong></h1><h2><strong>后台预下载</strong></h2><p>预下载是最直观的一种方法，既然不能直接引用，那我就先后台下载下来，然后将图片链接到下载后的图片即可。这个方法还是比较稳妥的，图片下载下来就是自己的了，不会再受人限制。不过这总有种侵犯知识产权的感觉，而且每张图片都要后台先下载，逻辑处理起来还是有点麻烦的；而且对于那种纯静态页面，没有后台程序供我们发挥，这也就无法实现了。</p><h2><strong>第三方代理</strong></h2><p>第三方代理其实算是后台与下载的升级版，其实就是将下载图片的这个过程交给第三方的网站。一个非常好用的代理是<a href=\"https://images.weserv.nl/\" target=\"_blank\" style=\"color: rgb(0, 153, 204);\">images.weserv.nl</a>，我们可以直接将自己需要“盗链”的图片写在请求中即可。我们甚至可以指定一些简单的图片处理参数，让代理帮我们处理。</p><p>比如我想盗链<code>https://foo.com/foo.jpg</code>，并且将图片宽度设置成100，我们就可以直接这样引用:</p><blockquote><span style=\"color: rgb(0, 111, 224);\">&lt;</span><span style=\"color: teal;\">img </span><span style=\"color: rgb(0, 45, 122);\">src</span><span style=\"color: rgb(0, 111, 224);\">=</span><span style=\"color: rgb(221, 17, 68);\">\"https://images.weserv.nl/?url=foo.com/foo.jpg&amp;w=100\"</span><span style=\"color: rgb(0, 111, 224);\"> /&gt;</span></blockquote><p>这还是很方便的，不过美中不足的是这个国外的网站在国内的访问速度似乎有点慢，有时候甚至还会被墙，这就有点尴尬了。</p><h2><strong>删除Header中的Referrer</strong></h2><p>相比上面两种折腾的方法，如果能直接修改Referrer，那不就省了很多事了么。但是事实上这里的配置还是有挺多坑的，方法也有很多种，一不小心就会跟我一样踩了一遍又一遍。</p><h3>添加meta标签</h3><p>一种方法是给页面添加一个meta标签，在meta标签里指定referrer的值，比如。网上可以查到各种奇奇怪怪的值，其实我总结了来源于两个地方。</p><p>一个是来自<a href=\"https://wiki.whatwg.org/wiki/Meta_referrer\" target=\"_blank\" style=\"color: rgb(0, 153, 204);\">whatwg</a>的标准。他给meta标签的referrer属性定义了四个值：<code>never,always,origin,default</code>。如果需要关闭referrer，就将referrer的值设置成”never”。这个标准还是比较老的，而且在他的主页上也明确写了”This document is obsolete.”。不过据我调研，或许正是由于这个标准比较老，反而导致绝大多数浏览器对他的支持都很好，因祸得福蛤蛤。</p><p>另外一个是来自<a href=\"https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/meta\" target=\"_blank\" style=\"color: rgb(0, 153, 204);\">MDN</a>的标准。他给meta标签的referrer属性定义了五个值，如果要关闭referrer，就将它的值设置成<code>no-referrer</code>。</p><p>不过我们需要注意的是，meta标签添加的位置也很重要，有的浏览器能够识别非head标签中的meta标签，有的就不行。在实际使用的时候还要小心，这一点下文会有一个更具体的比较。</p><h3>添加ReferrerPolicy属性</h3><p>添加meta标签相当于对文档中的所有链接都取消了referrer，而ReferrerPolicy则更精确的指定了某一个资源的referrer策略。关于这个策略的定义可以参照<a href=\"https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Referrer-Policy\" target=\"_blank\" style=\"color: rgb(0, 153, 204);\">MDN</a>。比如我想只对某一个图片取消referrer，如下编写即可:</p><blockquote><span style=\"color: rgb(0, 111, 224);\">&lt;</span><span style=\"color: teal;\">img </span><span style=\"color: rgb(0, 45, 122);\">src</span><span style=\"color: rgb(0, 111, 224);\">=</span><span style=\"color: rgb(221, 17, 68);\">\"xxxx.jpg\"</span><span style=\"color: rgb(0, 111, 224);\">&nbsp;&nbsp;</span><span style=\"color: rgb(0, 45, 122);\">referrerPolicy</span><span style=\"color: rgb(0, 111, 224);\">=</span><span style=\"color: rgb(221, 17, 68);\">\"no-referrer\"</span><span style=\"color: rgb(0, 111, 224);\"> /&gt;</span></blockquote><p><br></p>', '1', '前端', '', '7', null, null);
INSERT INTO `article` VALUES ('50', '1', 'React div 实现一个 textarea', '2018-05-13 23:24:31', '<p>看到标题，老爷们肯定不满意，切，用 div 实现一个 textarea 有啥难度，不就是 <code>contenteditable</code> 吗？</p><p>看到 React，又要多加一句：切，跟用什么库有什么关系。实际上在使用的时候，我还是遇到了一点微小的麻烦。</p><h3>全选</h3><p>在 textarea 中，全选只需要使用 <code>element.select()</code> 就可以，它的作用是：</p><p><br></p><p><br></p><blockquote>The HTMLInputElement.select() method selects all the text in a <code>&lt;textarea&gt;</code> element or an <code>&lt;input&gt;</code> element with a text field.</blockquote><p>然而在 <code>div</code> 中，没有这样的函数，所以需要自己划定范围并且选中：</p><p><br></p><p><br></p><pre class=\"ql-syntax\" spellcheck=\"false\">const selection = window.getSelection()\nconst range = document.createRange()\nrange.selectNodeContents(this.textInput) // DOM\nselection.removeAllRanges()\nselection.addRange(range)\n</pre><h3>纯文字的切换</h3><p>在 <code>textarea</code> 中，所有内容都会变成文本，但是在 <code>div</code> 中，我们很容易受到转义的影响。</p><p>尽管 <code>user-modify: read-write-plaintext-only;</code> 这个可以免于标签注入的烦恼，但是依旧会遇到换行的问题，换行操作在 <code>div</code> 中是 <code>&lt;br /&gt;</code>，对于文本来说是 <code>\\n</code>，于是，我们还需要在转换时做一遍替代：</p><p><br></p><p><br></p><pre class=\"ql-syntax\" spellcheck=\"false\">this.initInput = input.replace(/\\n/g, \'&lt;br /&gt;\')\n</pre><h3>无警告渲染的方式</h3><p>在 React 中，如果你用 <code>div</code> 取代输入，会有一个 warning 警告，虽然不影响使用，但是 warning 总是让人浑身难受，这种时候以下两个属性可以避免这个烦恼：</p><p><br></p><p><br></p><pre class=\"ql-syntax\" spellcheck=\"false\">suppressContentEditableWarning={true}\ndangerouslySetInnerHTML={{ __html: this.initInput }}\n</pre><p>剩下的都不是什么大问题，相信大家是能搞定的！</p>', '1', '前端', 'React,textarea', '19', null, '/static/images/articleCover/1527404030910.jpeg');
INSERT INTO `article` VALUES ('51', '1', 'Google ML Kit 中文文档上线 | 掘金翻译计划', '2018-05-13 23:36:52', '<p>在近期 Google I/O 大会为其 Firebase 开发平台推出了一款新的机器学习 SDK ，名为 \"ML Kit\" 。与之前的 Core ML 不太相同，这次的新的SDK为一些最常见的计算机视觉用例提供了现成的 API，实际上这允许了那些即使不是机器学习专家的开发人员，尤其是安卓和 iOS 端的开发人员，在自己的应用程序中添加属于自己的机器学习。此外，它还支持导入自定义的 TensorFlow Lite 模型。</p><p>以下是它的核心功能列表**（摘自文档）**</p><p>为工程应用的常见用例 ML Kit附带了一套用于常见移动用例的随时可用的API：文本识别、人脸识别、地标识别、条形码识别和图像标注等。只需将数据传递给ML kit库，它就能够给您提供您想要的信息。 在手机设备上或者云端运行 ML kit所选用的API可以在设备上运行或者在云上运行。我们的设备上提供的API即使在没有网络连接的情况下也可以快速地处理您的数据。另一方面，我们基于云端的API则是利用了Google&nbsp;Cloud Platform提供的强大的机器学习功能。可以为您提供更高的准确度。 装载自有模型 而如果ML kit提供的API并不符合您的需求，您可以随时使用您的现有TensorFlow Lite模型。只需要将您的模型上传到Firebase中，我们就会负责托管并将其投放到您的应用当中去。ML kit在这个过程中充当了您的自定义模型的API层，使其更易于运行和使用。 通常情况下，建立一个机器学习环境是一项艰巨的工作。您必须学习如何使用像 TensorFlow 这样的机器学习库，还必须获取一大堆数据来训练您的模型。然后，您还得输出一个足够轻量的模型（此处为转换为 TensorFlow Lite ，这个在此次推出的 SDK 中也被完美支持）。而 ML Kit 简化了这一个流程，您只需要在 Firebase 上调用某些机器学习特性即可。</p><p>此外它也推出了 <strong>On-device</strong> 特性，就是您可以为您的应用程序就仅仅是设置了单机运行。以下为支持的列表</p><p>特性 设备 云端 文本识别 √ √ 人脸识别 √ × 条形码识别 √ × 图像标记 √ √ 地标识别 × √ 自定义模型装载 √ × 对于国内的开发者，这里提供的视觉 API 仅有地标识别不提供 On-device 功能。其它都是可以在国内的手机上运行。而如果有需要， Firebase 也提供了相对应的 Cloud API 。仅有条形码扫描和人脸识别功能并不提供云端识别功能。云端的服务都是前1000次使用不会收费。</p><p>对于已经对机器学习有了解或者当前 API 并不满足需求的开发者，ML Kit 也提供了自定义模型和自定义 TensorFlow Lite 版本的功能。只需要跟着文档一步步操作，就能够实现将 TensorFlow 模型转为 TensorFlow Lite 的需求。</p><p>而且，如果是自定义模型。您可以为其定义非 Firebase 的托管位置。意味着您可以在国内的服务器上挂靠您的模型，并且在您的应用程序中实时下载模型。不过由于模型的储存并没有进行过多的加密。因此有一定的不安全性。但是谷歌认为模型和应用程序是高度集合的。所以这点并不会影响过多。</p><p>总之，以上是 ML Kit 文档中提及的一小部分内容。</p><p>因此在功能以及文档推出后，我尽快将文档翻译和校对了一遍，并且上传到了 GitHub 。以后将继续维护。欢迎大家前去阅览，提出修改意见。地址为：<a href=\"https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FQuorafind%2FMLkit-CN\" target=\"_blank\">ML Kit-CN</a> 。</p>', '2', '人工智能', 'Google,中文文档', '24', null, '');
INSERT INTO `article` VALUES ('52', '1', '换个角度提升APP性能和质量', '2018-05-16 21:41:23', '<h2><strong>摘要</strong></h2><p><br></p><p>结合当下火热的移动性能话题和 APM 系统，围绕移动应用性能质量，谈谈如何避开传统解决方案，将其他技术领域的概念如回流重绘，节流防抖、优雅降级以及渐进增强等，通过类比借鉴，作为一个新的角度来思考质量提升问题，并灵活的运用到移动端，从而提升应用的性能，稳定性和可用性。</p><p><br></p><p>刚加入饿了么的时候做了一年左右的业务线，主要是商务平台。在更早之前做过web开发。最近刚好在开发web相关的项目，觉得很多东西各个端是共通的，APP端也能借鉴一些东西，把之前的老经验带到移动端上，来做有意思的事情。</p><p><br></p><h2><strong>分享大纲</strong></h2><p><br></p><p>第一，移动性能与质量的概述 </p><p>第二，所谓的“新”技术概念的介绍</p><p>第三，几点有意思的事和一些困难</p><p><br></p><h2><strong>移动性能与质量的概述</strong></h2><p><br></p><p>饿了么的用户端不会出现高峰期的现象，订餐时间都选在中午之前的一到两个小时，量级非常大。我们内部有其他很多业务线，针对与配送人员和商户的客户端，还有供应链，以及内部的沟通工具。我们内部会简单地做分析优良中差评做分级。</p><p><br></p><p>最早是以崩溃来算，但后来崩溃在后期并不是特别看重。崩溃率高包括ANR多这一类肯定是差，只能轮为可用的阶段。而好用的阶段除了UPM做指导性的工作，还要做非常深化的业务，我们一个框架部对外一直在输出各种SDK，供内部使用。</p><p><br></p><p>根据设备类型，除了在跑移动端，还有PC以及外围。PC基本上没有跑流量、耗电量的问题。结合主要的业务场景，我们面临的问题是用户端停留在用户手上的时间很短暂，而商户端和配送端一直开着APP。对配送人员来讲优先考虑的是耗电问题，耗电问题在移动端的体现有两点，网络和定位。GPS定位非常耗电，不停定位还要提升精度，是对物流端APP最大的挑战。其次对商户端考虑的是网络的优化和性能，本身网络环境是相对比较好的，我们主要提升它的APP到达和业务方面。</p><p><br></p><h2><strong>所谓的“新”技术概念介绍</strong></h2><p><br></p><p>我们经常遇到的回流和重绘问题。这个问题很经典，从最初的页面加载到最后绘制在屏幕上。回流是在流失布局下，参照元素的布局坐标一旦发生了改变，那所有依赖它的元素都要重排，重新计算布局位置的过程，尤其消耗UPC。</p><p><br></p><p>重绘是不发生重排的情况下重新布局，现在的GPU都那么强大，性能并不是瓶颈。</p><p><br></p><p>下面是我们处理商品订单的问题，订单当时是检测到有很多用户的投诉，订单改版之后性能特别差。性能主要是卡在CPU上，CPU在计算的时候是非常慢的。</p><p><br></p><p>最终我们优化的结果非常好。虽然它也要做布局计算，但在快速滚动的时候帧率是达到非常满意的情况，基本上接近于60帧。</p><p>前端在滚动页面的时候需要做一些效果，在滚动时监听。在很高的频率下不停地设计元素的位置，会导致滚动时的卡顿问题。而前端用的解决方法就是节流。</p><p><br></p><p>我们的做法还应用于正在开发的APM台。我们有一个数据收集的问题，数据收集的数额大，频次也快，用户的轨迹分析的数据很多。我们在服务器传送数据的时候如果失败的话，基本上为了保证数据传输过去，对于非实质性数据一定要把它传过去，就存在了自动重试的问题。我把它定位为“黄金”重试节流策略。</p><p>接下来渐进增强和优雅降级。Graceful Degradation是对于出现某种情况不停地做减法。对于外围来讲，浏览器的碎片化特别重复，安卓端也有这种问题。如果它的功能不可用，就把这个功能减掉。还有渐进式增强，依赖浏览器IE6，设计一套基本的功能能在上面用，不停地做架构，直到它表现的非常好。利用更优组件，三方作为备选。操作效率会出现问题，操作效率和速度是随着失效部件的增加逐渐下降的。我的设计就是这样的框架，很简单的，先建长连，可控可靠，存在异常就降级。</p><p><br></p><p>最后讲法则。零崩溃零错误等于好用；启动时间Main后比Main前重要；二进制大于资源，耗件优化，硬件大于软件。</p><p><br></p><h2><strong>有意思的事和一些困难</strong></h2><p><br></p><p>关于耗电问题。手机设备在通讯的时候处于休眠期，当你有需求的时候会自动开启活跃期，活跃期和停歇期切换频繁的话，电量就掉的非常快。我们的弱网判断是针对与它的响应时间，我们自己做的网络框架可以知道所有的DSR包括数据时间。</p><p><br></p><p>我们拿来之后发现超时间，网络响应时间太长。这种情况下会做节流层，要么不传数据，要么降低发送频率。合理的缓存和批量的传输。大家有时候也会要求实质性非常高的数据往后端发，用户点击一搜就把数据转换成事件，可这样的情况下瞬间发送服务器还是会崩溃。我们做一个简单的调整，就是做忍受值。我们认为数据从生成劳动发送到传输，传输的时候查过最慢的DNS解析是80秒，是非常非常差的网络插件。我们认为有忍受值，目前设定的单位是60秒钟，60秒钟的数据都认为它是有实时属性、架构的才往后端传。一旦出超过60秒，就从传输队列去掉。对我们传输的间隔也会调整，除了一系列网络的节流优化，加上这套实施策略，极大地提升了网络的效率和节点问题。</p><p><br></p><p>最终我们还会发现通过APM平台会发现主机解析率特别高的，能达到86%。存在这样的失败率的网络软件，而且还是每台不停地发，能看到它发送的频率。我们是天网系统，是会开源的，服务器端的代码也会开源的，只是服务不会去做。</p><p><br></p><p>今天基本上就讲这么多，谢谢大家！</p>', '1', '阅读', 'APP,性能,质量', '113', null, '/static/images/articleCover/1527043110323.jpeg');

-- ----------------------------
-- Table structure for `articlecomment`
-- ----------------------------
DROP TABLE IF EXISTS `articlecomment`;
CREATE TABLE `articlecomment` (
  `commentID` int(11) NOT NULL AUTO_INCREMENT,
  `articleID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`commentID`),
  KEY `articleComment_articleID` (`articleID`),
  KEY `articleComment_userID` (`userID`),
  CONSTRAINT `articleComment_articleID` FOREIGN KEY (`articleID`) REFERENCES `article` (`articleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articleComment_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of articlecomment
-- ----------------------------
INSERT INTO `articlecomment` VALUES ('1', '1', '1', '厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥厉害了我的哥', '2018-05-15 20:56:36');
INSERT INTO `articlecomment` VALUES ('2', '1', '2', '啦啦啦啦啦', '2018-05-15 23:06:42');
INSERT INTO `articlecomment` VALUES ('10', '50', '1', '123', '2018-05-16 11:58:57');
INSERT INTO `articlecomment` VALUES ('11', '49', '2', '123', '2018-05-16 12:06:50');
INSERT INTO `articlecomment` VALUES ('15', '1', '2', 'rest', '2018-05-16 12:37:16');
INSERT INTO `articlecomment` VALUES ('16', '1', '2', '＠danxiong1995 123', '2018-05-16 12:37:27');
INSERT INTO `articlecomment` VALUES ('32', '1', '2', 'test', '2018-05-16 14:52:48');
INSERT INTO `articlecomment` VALUES ('33', '1', '2', '123', '2018-05-16 14:53:02');
INSERT INTO `articlecomment` VALUES ('34', '1', '2', '21', '2018-05-16 14:53:30');
INSERT INTO `articlecomment` VALUES ('35', '1', '2', '333', '2018-05-16 14:56:32');
INSERT INTO `articlecomment` VALUES ('37', '52', '1', '厉害了我的哥', '2018-05-16 21:42:04');
INSERT INTO `articlecomment` VALUES ('38', '52', '1', '膜拜大神', '2018-05-16 21:43:32');
INSERT INTO `articlecomment` VALUES ('41', '52', '1', 'test', '2018-05-26 20:52:44');
INSERT INTO `articlecomment` VALUES ('60', '52', '1', '123', '2018-05-26 21:17:58');
INSERT INTO `articlecomment` VALUES ('61', '52', '1', 'test', '2018-05-26 21:18:21');
INSERT INTO `articlecomment` VALUES ('64', '52', '1', 'test', '2018-05-27 10:07:24');
INSERT INTO `articlecomment` VALUES ('65', '52', '1', '123', '2018-05-27 10:07:36');
INSERT INTO `articlecomment` VALUES ('66', '52', '1', '321', '2018-05-27 10:28:37');
INSERT INTO `articlecomment` VALUES ('67', '52', '1', 'r', '2018-05-27 10:28:52');
INSERT INTO `articlecomment` VALUES ('68', '52', '1', '32131', '2018-05-27 10:29:27');
INSERT INTO `articlecomment` VALUES ('69', '49', '1', '菜鸟', '2018-05-27 21:55:13');
INSERT INTO `articlecomment` VALUES ('70', '52', '1', 'test', '2018-05-31 11:59:28');
INSERT INTO `articlecomment` VALUES ('71', '52', '1', 'test1', '2018-05-31 11:59:41');

-- ----------------------------
-- Table structure for `collection`
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection` (
  `collectionID` int(11) NOT NULL,
  `collectionName` varchar(20) NOT NULL DEFAULT 'default',
  `userID` int(11) NOT NULL,
  `articleID` int(11) NOT NULL,
  PRIMARY KEY (`collectionID`,`articleID`),
  KEY `collection_userID` (`userID`),
  KEY `collection_articleID` (`articleID`),
  CONSTRAINT `collection_articleID` FOREIGN KEY (`articleID`) REFERENCES `article` (`articleID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `collection_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of collection
-- ----------------------------
INSERT INTO `collection` VALUES ('1', 'default', '1', '4');
INSERT INTO `collection` VALUES ('1', 'default', '1', '5');

-- ----------------------------
-- Table structure for `favoritearticle`
-- ----------------------------
DROP TABLE IF EXISTS `favoritearticle`;
CREATE TABLE `favoritearticle` (
  `userID` int(11) NOT NULL,
  `articleID` int(11) NOT NULL,
  PRIMARY KEY (`articleID`,`userID`),
  KEY `favorite_userID` (`userID`),
  CONSTRAINT `favorite_articleID` FOREIGN KEY (`articleID`) REFERENCES `article` (`articleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `favorite_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of favoritearticle
-- ----------------------------
INSERT INTO `favoritearticle` VALUES ('1', '1');
INSERT INTO `favoritearticle` VALUES ('1', '8');
INSERT INTO `favoritearticle` VALUES ('1', '28');
INSERT INTO `favoritearticle` VALUES ('1', '42');
INSERT INTO `favoritearticle` VALUES ('1', '43');
INSERT INTO `favoritearticle` VALUES ('1', '44');
INSERT INTO `favoritearticle` VALUES ('1', '48');
INSERT INTO `favoritearticle` VALUES ('1', '49');
INSERT INTO `favoritearticle` VALUES ('1', '50');
INSERT INTO `favoritearticle` VALUES ('1', '51');
INSERT INTO `favoritearticle` VALUES ('1', '52');
INSERT INTO `favoritearticle` VALUES ('2', '1');
INSERT INTO `favoritearticle` VALUES ('2', '2');
INSERT INTO `favoritearticle` VALUES ('2', '11');
INSERT INTO `favoritearticle` VALUES ('2', '12');
INSERT INTO `favoritearticle` VALUES ('2', '13');
INSERT INTO `favoritearticle` VALUES ('2', '14');
INSERT INTO `favoritearticle` VALUES ('2', '15');
INSERT INTO `favoritearticle` VALUES ('2', '17');
INSERT INTO `favoritearticle` VALUES ('2', '34');
INSERT INTO `favoritearticle` VALUES ('2', '51');

-- ----------------------------
-- Table structure for `favoritereply`
-- ----------------------------
DROP TABLE IF EXISTS `favoritereply`;
CREATE TABLE `favoritereply` (
  `commentID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`userID`,`commentID`),
  KEY `reply_commentID` (`commentID`),
  CONSTRAINT `reply_commentID` FOREIGN KEY (`commentID`) REFERENCES `articlecomment` (`commentID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reply_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of favoritereply
-- ----------------------------

-- ----------------------------
-- Table structure for `favoritetrend`
-- ----------------------------
DROP TABLE IF EXISTS `favoritetrend`;
CREATE TABLE `favoritetrend` (
  `trendID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`trendID`,`userID`),
  KEY `favoriteTrend_user_userID` (`userID`),
  CONSTRAINT `favoriteTrend_trend_trendID` FOREIGN KEY (`trendID`) REFERENCES `trend` (`trendID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `favoriteTrend_user_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of favoritetrend
-- ----------------------------
INSERT INTO `favoritetrend` VALUES ('1', '1');
INSERT INTO `favoritetrend` VALUES ('3', '1');
INSERT INTO `favoritetrend` VALUES ('4', '1');
INSERT INTO `favoritetrend` VALUES ('5', '1');
INSERT INTO `favoritetrend` VALUES ('9', '1');
INSERT INTO `favoritetrend` VALUES ('16', '1');
INSERT INTO `favoritetrend` VALUES ('17', '1');
INSERT INTO `favoritetrend` VALUES ('10', '2');

-- ----------------------------
-- Table structure for `follower`
-- ----------------------------
DROP TABLE IF EXISTS `follower`;
CREATE TABLE `follower` (
  `userID` int(11) NOT NULL,
  `followerUserID` int(11) NOT NULL,
  PRIMARY KEY (`userID`,`followerUserID`),
  KEY `follower_followerUserID` (`followerUserID`),
  CONSTRAINT `follower_followerUserID` FOREIGN KEY (`followerUserID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `follower_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of follower
-- ----------------------------
INSERT INTO `follower` VALUES ('2', '1');
INSERT INTO `follower` VALUES ('4', '1');
INSERT INTO `follower` VALUES ('26', '1');
INSERT INTO `follower` VALUES ('1', '2');
INSERT INTO `follower` VALUES ('1', '3');
INSERT INTO `follower` VALUES ('2', '3');
INSERT INTO `follower` VALUES ('2', '4');
INSERT INTO `follower` VALUES ('3', '4');
INSERT INTO `follower` VALUES ('1', '5');
INSERT INTO `follower` VALUES ('2', '6');
INSERT INTO `follower` VALUES ('3', '8');
INSERT INTO `follower` VALUES ('3', '9');
INSERT INTO `follower` VALUES ('1', '10');

-- ----------------------------
-- Table structure for `serachhistory`
-- ----------------------------
DROP TABLE IF EXISTS `serachhistory`;
CREATE TABLE `serachhistory` (
  `keyword` varchar(50) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of serachhistory
-- ----------------------------
INSERT INTO `serachhistory` VALUES ('Android', '20');
INSERT INTO `serachhistory` VALUES ('bootstrap', '9');
INSERT INTO `serachhistory` VALUES ('Google', '23');
INSERT INTO `serachhistory` VALUES ('iOS', '12');
INSERT INTO `serachhistory` VALUES ('localStorage', '11');
INSERT INTO `serachhistory` VALUES ('mysql', '8');
INSERT INTO `serachhistory` VALUES ('nginx', '2');
INSERT INTO `serachhistory` VALUES ('node', '21');
INSERT INTO `serachhistory` VALUES ('vue.js', '30');
INSERT INTO `serachhistory` VALUES ('webpack', '37');
INSERT INTO `serachhistory` VALUES ('前端', '15');
INSERT INTO `serachhistory` VALUES ('单页面应用', '10');
INSERT INTO `serachhistory` VALUES ('反向代理', '28');
INSERT INTO `serachhistory` VALUES ('小程序', '22');
INSERT INTO `serachhistory` VALUES ('用户体验', '50');
INSERT INTO `serachhistory` VALUES ('跨域', '18');
INSERT INTO `serachhistory` VALUES ('面向对象', '19');

-- ----------------------------
-- Table structure for `trend`
-- ----------------------------
DROP TABLE IF EXISTS `trend`;
CREATE TABLE `trend` (
  `trendID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `content` text NOT NULL,
  `date` datetime NOT NULL,
  `favors` int(11) DEFAULT '0',
  `images` varchar(200) DEFAULT NULL,
  `topic` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`trendID`),
  KEY `trend_user_userID` (`userID`),
  CONSTRAINT `trend_user_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trend
-- ----------------------------
INSERT INTO `trend` VALUES ('1', '1', '今天是个好日子', '2018-05-12 10:09:53', '1', '/static/images/test1.jpg,/static/images/logo.png', '闲聊');
INSERT INTO `trend` VALUES ('2', '1', '我是谁，我怎么会在这里', '2018-05-12 10:10:21', '0', null, '闲聊');
INSERT INTO `trend` VALUES ('3', '2', '啦啦啦啦啦啦啦啦啦啦啦啦', '2018-05-11 09:10:38', '2', null, '闲聊');
INSERT INTO `trend` VALUES ('4', '4', '12345，上山打老虎', '2018-05-10 07:11:08', '1', null, '奋斗');
INSERT INTO `trend` VALUES ('5', '2', '托尔斯泰', '2018-05-12 13:47:11', '19', null, '人物');
INSERT INTO `trend` VALUES ('8', '1', '美女如云~', '2018-05-14 11:09:15', '0', '/static/images/trend/1526267354772.jpeg,static/images/trend/1526267354775.jpeg', '人物');
INSERT INTO `trend` VALUES ('9', '1', '今天是个好日子', '2018-05-14 11:10:37', '1', '/static/images/trend/1526267437240.jpeg,/static/images/trend/1526267437244.jpeg,/static/images/trend/1526267437249.jpeg', '闲聊');
INSERT INTO `trend` VALUES ('10', '1', '撩闲', '2018-05-14 11:22:47', '1', '/static/images/trend/1526268166569.jpeg', '人物');
INSERT INTO `trend` VALUES ('16', '2', '青春不再，毕业快乐！', '2018-05-19 00:47:32', '21', '/static/images/trend/1526716051525.jpeg,/static/images/trend/1526716051530.jpeg', '奋斗');
INSERT INTO `trend` VALUES ('17', '1', '十年奋斗，只为今朝！！！', '2018-05-19 15:51:17', '20', '/static/images/trend/1526716277492.jpeg,/static/images/trend/1526716277493.jpeg,/static/images/trend/1526716277495.jpeg,/static/images/trend/1526716277497.jpeg', '奋斗');

-- ----------------------------
-- Table structure for `trendcomment`
-- ----------------------------
DROP TABLE IF EXISTS `trendcomment`;
CREATE TABLE `trendcomment` (
  `trendCommentID` int(11) NOT NULL AUTO_INCREMENT,
  `trendID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `content` text NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`trendCommentID`),
  KEY `trendComment_trend_trendID` (`trendID`),
  KEY `trendComment_user_userID` (`userID`),
  CONSTRAINT `trendComment_trend_trendID` FOREIGN KEY (`trendID`) REFERENCES `trend` (`trendID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `trendComment_user_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trendcomment
-- ----------------------------
INSERT INTO `trendcomment` VALUES ('24', '16', '1', '毕业快乐', '2018-05-23 17:39:22');

-- ----------------------------
-- Table structure for `trendtopic`
-- ----------------------------
DROP TABLE IF EXISTS `trendtopic`;
CREATE TABLE `trendtopic` (
  `title` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT '暂无任何描述',
  `cover` longtext,
  `trendNumber` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trendtopic
-- ----------------------------
INSERT INTO `trendtopic` VALUES ('人物', '暂无任何描述', '/static/images/test1.jpg', '0');
INSERT INTO `trendtopic` VALUES ('奋斗', '暂无任何描述', '/static/images/test2.jpg', '0');
INSERT INTO `trendtopic` VALUES ('闲聊', '暂无任何描述', '/static/images/test3.jpg', '0');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(20) NOT NULL,
  `password` varchar(15) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `email` varchar(20) NOT NULL,
  `avatar` varchar(200) DEFAULT NULL,
  `job` varchar(20) DEFAULT NULL,
  `company` varchar(20) DEFAULT NULL,
  `introduce` varchar(255) DEFAULT NULL,
  `blogAddr` varchar(255) DEFAULT NULL,
  `isAdmin` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `unique_phone` (`phone`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_userName` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'danxiong', '12345', '13432804015', '724547289@qq.com', '/static/images/avatar/1527579145754.jpeg', '无业游民', '有限公司', '', 'github.com/mrdanx', '0');
INSERT INTO `user` VALUES ('2', 'Christine', '123', '13545845214', '724547279@qq.com', '/static/images/avatar/1526966624045.jpeg', '自由职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('3', 'Agora', '123', '13432804016', '845154785@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('4', '根号三', '123', '13432804017', '548547564@qq.com', '/static/images/avatar/1526966624045.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('5', 'AI前线', '123', '13432804018', '458554851@qq.com', '/static/images/avatar/1526967414351.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('6', '小秋', '123', '13432804019', '13432804019@163.com', '/static/images/avatar/1526966624045.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('8', 'danxiong1990', '123', '13432804415', '7245471@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('9', 'danxiong1999', '123', '13432545842', '123123@qq.com', '/static/images/avatar/1526967414351.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('10', 'yandadiao', '123', '13432541254', '123123123@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('11', 'yandadiao1', '123', '13432541257', '58452458@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('12', 'danxiong123', '123', '13432145214', '123123111@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('13', 'yandadaio2', '123', '13458745214', 'qqjji@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('14', 'danxiong110', '123', '13425487541', '123321@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('15', 'danxiong198', '123', '13458452125', '2222@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('16', 'danxiong1238', '123', '13542154421', '2415q@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('17', 'danxiong231', 'dx123', '13432025121', '123213@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('18', 'danxiong5465', '123456', '13436584085', 'danxiong@qq.com', '/static/images/avatar/1526967414351.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('21', 'danxiong2000', '123', '13541245124', '85424584@qq.com', '/static/images/avatar/1526966624045.jpeg', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('23', 'danxiogn2001', '123', '15245154215', '123458548@qq.con', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('24', 'danxiong2002', '123', '13584521542', '123123a@qq.com', '/static/images/avatar/default-avatar.png', '添加职业', null, '这家伙很懒，啥都没写！', null, '0');
INSERT INTO `user` VALUES ('25', 'danxiong2003', '123', '13548452145', '547854785@qq.com', '/static/images/avatar/1526967414351.jpeg', null, null, null, null, '0');
INSERT INTO `user` VALUES ('26', 'danxiogn2004', '123', '13554258458', '123484568@qq.com', '/static/images/avatar/1526967603363.jpeg', '', '', '', null, '0');
INSERT INTO `user` VALUES ('27', 'danxiong1234', '123456', '13584562154', 'danxiong1123@qq.com', '/static/images/avatar/1527331982718.jpeg', null, null, null, null, '0');
INSERT INTO `user` VALUES ('28', '了解更多见', '123456', '13017171637', '2134@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');
INSERT INTO `user` VALUES ('29', 'danxiong1998', '123456', '15814875485', '856372819@qq.com', '/static/images/avatar/1527511814825.jpeg', null, null, null, null, '0');
INSERT INTO `user` VALUES ('30', 'danixong999', 'dx123456', '15325458420', '57487547@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');
INSERT INTO `user` VALUES ('31', 'danxiong123123', 'dx123456', '15625485475', '1235648@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');
INSERT INTO `user` VALUES ('32', 'danxiong321', 'dx123', '15745874547', '478577854@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');
INSERT INTO `user` VALUES ('33', 'danxiong4', 'dx123456', '15874574584', '1213123@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');
INSERT INTO `user` VALUES ('34', 'danxiong284', '1233', '13432804011', '587458@qq.com', '/static/images/avatar/default-avatar.png', null, null, null, null, '0');

-- ----------------------------
-- View structure for `articledetail`
-- ----------------------------
DROP VIEW IF EXISTS `articledetail`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `articledetail` AS select `a`.`articleID` AS `articleID`,`a`.`userID` AS `userID`,`a`.`title` AS `title`,`a`.`date` AS `date`,`a`.`content` AS `content`,`a`.`favors` AS `favors`,`a`.`subject` AS `subject`,`a`.`tags` AS `tags`,`a`.`pv` AS `pv`,`a`.`image` AS `image`,`a`.`cover` AS `cover`,`u`.`userName` AS `author`,`u`.`avatar` AS `avatar`,count(`ac`.`commentID`) AS `commentNum` from ((`article` `a` left join `articlecomment` `ac` on((`a`.`articleID` = `ac`.`articleID`))) join `user` `u` on((`u`.`userID` = `a`.`userID`))) group by `a`.`articleID` ;

-- ----------------------------
-- View structure for `articlelist`
-- ----------------------------
DROP VIEW IF EXISTS `articlelist`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `articlelist` AS select `a`.`articleID` AS `articleID`,`a`.`userID` AS `userID`,`a`.`title` AS `title`,`a`.`date` AS `date`,`a`.`content` AS `content`,`a`.`favors` AS `favors`,`a`.`subject` AS `subject`,`a`.`tags` AS `tags`,`a`.`pv` AS `pv`,`a`.`image` AS `image`,`a`.`cover` AS `cover`,`u`.`userName` AS `author`,`u`.`avatar` AS `avatar` from (`article` `a` join `user` `u`) where (`a`.`userID` = `u`.`userID`) ;

-- ----------------------------
-- View structure for `trendlist`
-- ----------------------------
DROP VIEW IF EXISTS `trendlist`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `trendlist` AS select `t`.`trendID` AS `trendID`,`t`.`userID` AS `userID`,`t`.`content` AS `content`,`t`.`date` AS `date`,`t`.`favors` AS `favors`,`t`.`images` AS `images`,`t`.`topic` AS `topic`,`u`.`avatar` AS `avatar`,`u`.`userName` AS `userName`,`u`.`job` AS `job`,`u`.`company` AS `company`,count(`tc`.`trendCommentID`) AS `commentNum` from ((`trend` `t` left join `trendcomment` `tc` on((`t`.`trendID` = `tc`.`trendID`))) left join `user` `u` on((`t`.`userID` = `u`.`userID`))) group by `t`.`trendID` order by `t`.`date` desc ;
DROP TRIGGER IF EXISTS `increaseArticleFavor`;
DELIMITER ;;
CREATE TRIGGER `increaseArticleFavor` AFTER INSERT ON `favoritearticle` FOR EACH ROW begin

    UPDATE article SET favors=favors+1 WHERE articleID=new.articleID;

end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `decreaseArticleFavor`;
DELIMITER ;;
CREATE TRIGGER `decreaseArticleFavor` AFTER DELETE ON `favoritearticle` FOR EACH ROW begin

    UPDATE article SET favors=favors-1 WHERE articleID=old.articleID;

end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `increaseTrendFavor`;
DELIMITER ;;
CREATE TRIGGER `increaseTrendFavor` AFTER INSERT ON `favoritetrend` FOR EACH ROW begin

    UPDATE trend SET favors=favors+1 WHERE trendID=new.trendID;

end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `decreaseTrendFavor`;
DELIMITER ;;
CREATE TRIGGER `decreaseTrendFavor` AFTER DELETE ON `favoritetrend` FOR EACH ROW begin

    UPDATE trend SET favors=favors-1 WHERE trendID=old.trendID;

end
;;
DELIMITER ;
