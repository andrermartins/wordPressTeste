package com.mattism.http.wordpress
{
	/**
	 * @author		Matt Shaw <matt AT mattism. DOT com>
	 * @description	WordPress.as
	 * @see			http://www.xmlrpc.com/metaWeblogApi
	 * 				http://www.sixapart.com/movabletype/docs/mtmanual_programmatic.html
	 *
	 *  metaWeblog.newPost (blogid, username, password, struct, publish) returns string
	 *  metaWeblog.editPost (postid, username, password, struct, publish) returns true
	 *	metaWeblog.getPost (postid, username, password) returns struct
	 *	metaWeblog.getRecentPosts (blogid, username, password, numberOfPosts)
	 *
	 *	@requires	http://xmlrpcflash.mattism.com
	 */

	import com.mattism.http.xmlrpc.Connection;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	import com.mattism.http.xmlrpc.vo.Categoria;

	import flash.events.ErrorEvent;
	import flash.events.Event;

	import mx.collections.ArrayCollection;

	public class WordPress
	{

		/*
		 * Using the direct url gives you a sandbox violation (if you are coming from a different domain)
		 * So I'm using a PHP script to proxy the call. The source for that script is here:
		 * http://xmlrpcflash.mattism.com/proxy_info.php
		 */
		//public var SERVICE_URL:String = "http://xmlrpcflash.wordpress.com/xmlrpc.php";)
		public var SERVICE_URL:String = "http://xmlrpcflash.mattism.com/xmlrpc_proxy.php?url=http://xmlrpcflash.wordpress.com/xmlrpc.php";

		public var blog_id:String = "";
		public var username:String = "";
		public var password:String = "";

		private var METHOD_NEW_POST:String = "metaWeblog.newPost";
		private var METHOD_GET_POST:String = "metaWeblog.getPost";
		private var METHOD_EDIT_POST:String = "metaWeblog.editPost";
		private var METHOD_GET_RECENT_POSTS:String = "metaWeblog.getRecentPosts";
		private var METHOD_GET_CATEGORIES:String = "metaWeblog.getCategories";

		private var _callBackFunction:Function;

		private var _rpc:Connection;

		public function WordPress(username:String = "", password:String = "", serviceURL:String = ""):void
		{
			this.username = username;
			this.password = password;
			this.SERVICE_URL = serviceURL;

			_rpc = new ConnectionImpl(SERVICE_URL);
			_rpc.addEventListener(Event.COMPLETE, rpcSuccessHandler);
			_rpc.addEventListener(ErrorEvent.ERROR, rpcFaultHandler);
		}

		public function newPost(title:String, content:String, callBackFunction:Function, categories:ArrayCollection = null):void
		{
			var categoriesArray:Array = [];
			for each (var category:Categoria in categories)
			{
				categoriesArray.push({value: category.categoryName});
			}

			var conteudo:Object = {title: title, description: content, categories: categoriesArray};

			var args:Array = [[blog_id, XMLRPCDataTypes.STRING], [username, XMLRPCDataTypes.STRING], [password, XMLRPCDataTypes.STRING], [conteudo, XMLRPCDataTypes.STRUCT], [true, XMLRPCDataTypes.BOOLEAN]];

			this._wpCall(METHOD_NEW_POST, args, callBackFunction);
		}

		public function editPost(post_id:Number, title:String, content:String):void
		{
			var args:Array = [
				//[blog_id, XMLRPCDataTypes.STRING],
				[post_id, XMLRPCDataTypes.STRING], [username, XMLRPCDataTypes.STRING], [password, XMLRPCDataTypes.STRING], [{title: title, description: content}, XMLRPCDataTypes.STRUCT], [true, XMLRPCDataTypes.BOOLEAN]];

			this._wpCall(METHOD_EDIT_POST, args);
		}

		public function getPost(post_id:Number):void
		{
			var args:Array = [
				//[blog_id, XMLRPCDataTypes.STRING],
				[post_id, XMLRPCDataTypes.STRING], [username, XMLRPCDataTypes.STRING], [password, XMLRPCDataTypes.STRING]];

			this._wpCall(METHOD_GET_POST, args);
		}

		public function getRecentPosts(post_count:Number):void
		{
			var args:Array = [[blog_id, XMLRPCDataTypes.STRING], [username, XMLRPCDataTypes.STRING], [password, XMLRPCDataTypes.STRING], [post_count, XMLRPCDataTypes.INT]];

			this._wpCall(METHOD_GET_RECENT_POSTS, args);
		}

		public function getCategories(callBackFunction:Function):void
		{
			var args:Array = [[blog_id, XMLRPCDataTypes.STRING], [username, XMLRPCDataTypes.STRING], [password, XMLRPCDataTypes.STRING]];

			this._wpCall(METHOD_GET_CATEGORIES, args, callBackFunction);
		}

		private function _wpCall(method:String, args:Array, callBackFunction:Function = null):void
		{
			_callBackFunction = callBackFunction;
			_rpc.removeParams();

			var i:Number;

			for (i = 0; i < args.length; i++)
			{
				_rpc.addParam(args[i][0], args[i][1]);
			}
			_rpc.call(method);
		}

		private function rpcSuccessHandler(e:Event):void
		{
			if (_callBackFunction != null)
			{
				_callBackFunction(_rpc.getResponse());
			}
		}

		private function rpcFaultHandler(e:ErrorEvent):void
		{
			if (_callBackFunction != null)
			{
				_callBackFunction(_rpc.getFault());
			}
		}
	}

/*
   REQUEST

   <?xml version="1.0"?>
   <methodCall>
   <methodName>metaWeblog.getPost</methodName>
   <params>
   <param>
   <value><i4>1829</i4></value>
   </param>
   <param>
   <value>Bull Mancuso</value>
   </param>
   <param>
   <value><base64>bm93YXk=</base64></value>
   </param>
   </params>
   </methodCall>

   RESPONSE
   <?xml version="1.0"?>

   <methodResponse>
   <params>
   <param>
   <value><struct>
   <member>
   <name>categories</name>
   <value>
   <array>
   <data>
   <value>Michegas</value>
   <value>Mind Bombs</value>
   <value>Rest &amp; Relaxation</value>
   <value>Two-Way-Web</value>
   </data>
   </array>
   </value>
   </member>
   <member>
   <name>dateCreated</name>
   <value>
   <dateTime.iso8601>20030729T10:59:48</dateTime.iso8601>
   </value>
   </member>
   <member>
   <name>description</name>
   <value>Blogger Ed Cone of Greensboro talks&amp;nbsp; about the several intersections he overlooks. That is: junctions of the public and the personal (which every blogger faces) and more particularly the contrasting voices of a newspaper columnist and a blogger (he is both) and the opportunities for a local conversation in a global medium.</value>
   </member>
   <member>
   <name>enclosure</name>
   <value>
   <struct>
   <member>
   <name>length</name>
   <value>
   <i4>11421281</i4>
   </value>
   </member>
   <member>
   <name>type</name>
   <value>audio/mpeg</value>
   </member>
   <member>
   <name>url</name>
   <value>http://media.skybuilders.com/lydon/cone.mp3</value>
   </member>
   </struct>
   </value>
   </member>
   <member>
   <name>link</name>
   <value>http://blogs.law.harvard.edu/lydon/2003/07/18#a187</value>
   </member>
   <member>
   <name>permaLink</name>
   <value>http://radio.weblogs.com/0001015/2003/07/29.html#a1829</value>
   </member>
   <member>
   <name>postid</name>
   <value>
   <i4>1829</i4>
   </value>
   </member>
   <member>
   <name>title</name>
   <value>Chris Lydon interview with Ed Cone</value>
   </member>
   <member>
   <name>userid</name>
   <value>
   <i4>1015</i4>
   </value>
   </member>
   </struct></value>

   </param>

   </params>

   </methodResponse>
 */
}