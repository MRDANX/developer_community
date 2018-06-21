# 基于Vue.js移动端开发者社区

# 系统展示
本系统包含的模块有文章显示模块、用户动态模块、搜索模块、登录模块、注册模块、文章发布模块和动态发表模块。
在线地址:http://dx.xiaoshouhu.top

# 1	文章显示模块
文章显示模块主要分为文章简要列表显示和文章详细内容显示两个界面，简要列表显示模块中用户可根据自己喜好在顶栏选择显示相应分类的文章，其中顶部热门推荐文章列表按按点赞数降序排序，而下列较为详细的文章列表则是按文章发布时间降序排序，如图6-1所示，也可自定义顶栏显示文章分类数目，如图6-2所示。文章详细内容显示界面如图6-3所示。

<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/1.png" width="40%">
<p style="text-align:center">图1 文章简要列表显示界面</p>
</div>


<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/2.png" width="40%">   
<p style="text-align:center">图2 文章自定义分类界面</p>
</div>
 
<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/3.png" width="40%">   
<p style="text-align:center">图3 文章详细内容显示界面</p>
</div>

# 2	用户动态模块
用户动态模块主要包括所有用户动态的列表和当前已登录用户所关注的用户的动态列表。
所有用户动态列表界面中，顶部为横向滚动热门动态简要列表，按用户点赞数降序排序，其下方所有用户动态列表，按动态创建日期降序排序，如图6-4所示。
而当前登录用户所关注的用户动态列表，仅仅显示已关注用户的动态列表，如图6-5所示。

<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/4.png" width="40%"> 
<p style="text-align:center">图4 所有用户动态的列表界面 </p>
</div>

<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/5.png" width="40%"> 
<p style="text-align:center">图5 已关注用户动态列表界面</p>
</div>

# 3	搜索模块
搜索模块包含默认横幅活动轮播图及热门文章和用户搜索两个子界面。默认界面为显示用户可能喜欢的热门文章及热门活动轮播图，如图6-6所示，用户可通过下拉默认界面或点击顶部搜索框进入搜索历史界面。搜索历史界面上方为热门搜索列表，下方为用户搜索历史，如图6-7所示，点击相应文本即可直接进入详细搜索结果界面。如图6-8和图6-9所示，分别为简略和详细搜索结果显示界面，简略搜索结果界面为用户一边输入一边请求服务端搜索当前已输入文本，为用户提供更快的搜索体验，而详细搜索结果界面则是为用户提供更为详细的搜索结果，其中搜索文章结果可按浏览量或获赞数降序排序。

<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/6.png" width="40%"> 
<p style="text-align:center">图6 默认搜索界面</p>    
</div>

<div  align=center>
 <img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/7.png" width="40%"> 
<p style="text-align:center">图7 搜索历史界面</p>					
</div>

<div  align=center>
 <img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/8.png" width="40%"> 
<p style="text-align:center">图8 简略搜索结果界面</p>	
</div>

<div  align=center>
 <img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/9.png" width="40%"> 
<p style="text-align:center">图9 详细搜索结果界面</p>	
</div>

# 4	登录模块
登录界面使用的是利用Vue.js编写的textInput可复用组件，添加获取和失去焦点动效，带给用户更好的体验，如图6-10所示。用户登录时账号或密码错误提示如图6-11所示。
<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/10.png" width="40%"> 
<p style="text-align:center">图10 用户登录界面 </p>
</div>

# 5	注册模块
此模块为注册新用户，用户需输入手机号、用户名和密码等信息进行注册，如图6-12所示。若用户输入部分信息有误则为在文本框上方显示相应的提示信息，提示信息分为两类，第一类为用户输入手机号或邮箱格式有误，该功能为在客户端使用正则表达式匹配用户输入信息，若有误则显示错误信息，第二类为用户名是否重复的查询，当用户输入用户名后该文本框失去焦点时，会发送异步请求，请求后端检查用户名是否重复的API，若用户名与已存在用户的用户名重复则显示用户名已被注册的提示信息，部分错误提示信息如图6-13所示。
      
<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/11.png" width="40%"> 
<p style="text-align:center">图11 用户注册界面</p>
</div>

<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/12.png" width="40%"> 
<p style="text-align:center">图12 注册信息有误提示</p>
</div>
                      
# 6	文章发布模块
文章发布模块如图6-13所示，其中文章标题、分类和文章内容为必填内容，如存在任意一个未填写或选择，则会显示相应的提示用户输入必填内容的提示信息。
<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/13.png" width="40%"> 
<p style="text-align:center">图13 文章发布界面 </p>
</div>
                          
# 7	动态发表模块
动态发表模块如图6-14所示，其中动态内容为必填项，图片为可选项，若未填写内容就点击发送则会显示相应的提示信息提醒用户输入要发表的动态内容。
<div  align=center>
<img src="https://raw.githubusercontent.com/MRDANX/developer_community/master/readme-images/14.png" width="40%"> 
<p style="text-align:center">图14 动态发布界面</p>
</div>
