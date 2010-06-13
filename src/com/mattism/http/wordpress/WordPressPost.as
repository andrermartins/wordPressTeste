package com.mattism.http.wordpress
{
 * /**
 * @author		Matt Shaw <matt AT mattism. DOT com>
 * @description	WpPost.as
 * 				
 * Quick and dirty for now
 */
public class WordPressPost {
	/*
	 	mt_allow_pings:1
		mt_allow_comments:1
		mt_text_more:undefined
		mt_excerpt:undefined
		categories:Uncategorized
		permaLink:http://xmlrpcflash.wordpress.com/2005/11/23/test2/
		link:http://xmlrpcflash.wordpress.com/2005/11/23/test2/
		title:undefined
		description:undefined
		postid:13
		userid:26578
		dateCreated:Sat Jan 1 00:00:00 GMT-0500 0
	*/
	
	public var mt_allow_pings:Number;		// 1
	public var mt_allow_comments:Number;	// 1
	public var mt_text_more:String;		// undefined
	public var mt_excerpt:String;			// undefined
	public var categories:Array;			// Uncategorized
	public var permaLink:String;			// http://xmlrpcflash.wordpress.com/2005/11/23/test2/
	public var link:String;				// http://xmlrpcflash.wordpress.com/2005/11/23/test2/
	public var title:String;				// undefined
	public var description:String;		// undefined
	public var postid:Number;				// 13
	public var userid:Number;				// 26578
	public var dateCreated:Date;			// Sat Jan 1 00:00:00 GMT-0500 0
	
	
	public function WordPressPost( data:Object ) {
		for (var key:String in data ){
			//trace(key + " = " + data[key]);
			this[key]=data[key];
		}
	}
}
}