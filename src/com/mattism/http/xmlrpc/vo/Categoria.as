package com.mattism.http.xmlrpc.vo
{

	[Bindable]
	public class Categoria
	{
		public var categoryDescription:String;
		public var categoryId:Number;
		public var categoryName:String;
		public var description:String;
		public var htmlUrl:String;
		public var parentId:Number;
		public var rssUrl:String;
		
		public function Categoria(obj:Object)
		{
			try
			{
				categoryDescription = obj.categoryDescription;
				categoryId = obj.categoryId;
				categoryName = obj.categoryName;
				description = obj.description;
				htmlUrl = obj.htmlUrl;
				parentId = obj.parentId;
				rssUrl = obj.rssUrl;
			}
			catch(erro:Error)
			{
				trace(erro.message)
			}
		}
	}
}