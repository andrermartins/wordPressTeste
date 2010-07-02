/*
 * It's always good to create classes kids.
 * This is just a quick example.
 */
import com.mattism.http.wordpress.WordPress;
import com.mattism.http.wordpress.WordPressPost;

function postIt()
{
	// bobo validation
	if(_root.title.text.length == 0)
	{
		_root.title.setStyle("backgroundColor", 0xFF0000);
		setTimeout(resetTextColor, 1000);
	}
	else if(_root.content.text.length == 0)
	{
		_root.content.setStyle("backgroundColor", 0xFF0000);
		setTimeout(resetTextColor, 1000);
	}
	else if(int(_root.post_id.text) > 0)
	{
		wp.editPost(int(_root.post_id.text), _root.title.text, _root.content.text, onEditPost);
	}
	else
	{
		wp.newPost(_root.title.text, _root.content.text, onNewPost);
	}
}

function onLoadPosts(posts:Array)
{
	_root.post_list.removeAll()
	_root.post_list.addItem({label: "(New Post)", title: "", description: "", postid: ""});

	for(i = 0; i < posts.length; i++)
	{
		var p:WordPressPost = new WordPressPost(posts[i]);
		//_root.title.text = p.title;
		//_root.content.text = p.description;
		p['label'] = p.title;
		_root.post_list.addItem(p);
	}
}

function getRecentPosts()
{
	_root.post_list.removeAll()
	post_list.addItem("Loading Posts...");
	wp.getRecentPosts(100, onLoadPosts);
}

function onNewPost(new_post_id:Number)
{
	_root.getRecentPosts();
	_root.post_id.text = new_post_id;
}

function onEditPost(success:Boolean)
{
	_root.getRecentPosts();
	//_root.title.text=_root.content.text=_root.post_id.text="";
}

function onSelectPost(p:WordPressPost)
{
	_root.title.text = p.title;
	_root.content.text = p.description;

	if(p.postid)
	{
		_root.post_id.text = p.postid;
		_root.post_id._visible = true;
		_root.post_id_txt._visible = true;
	}
	else
	{
		_root.post_id.text = "";
		_root.post_id._visible = false;
		_root.post_id_txt._visible = false;
	}
}

function resetTextColor()
{
	_root.title.setStyle("backgroundColor", 0xffffff);
	_root.content.setStyle("backgroundColor", 0xffffff)
}

var wp:WordPress = new WordPress();
wp.blog_id = "xmlrpcflash";
wp.username = "xmlrpcflash";
wp.password = "asdasd";

_root.post_id._visible = false;
_root.post_id_txt._visible = false;
_root.getRecentPosts();

post_list.addEventListener("change", {change: function(e:Object)
	{
		_root.onSelectPost(e.target.selectedItem);
	}});

