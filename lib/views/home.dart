import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newz/helper/data.dart';
import 'package:newz/helper/news.dart';
import 'package:newz/models/article_model.dart';
import 'package:newz/models/category_model.dart';
import 'package:newz/views/article_view.dart';
import 'package:newz/views/category_news.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = [];
  List<ArticleModel> article = [];

  bool _loading = true;
  @override
  void initState() {

    super.initState();
    categories = getcategorys();
    getNews();
  }
  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    article = newsClass.news;

    setState(() {
      _loading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("The"),
            Text("News", style: TextStyle(color: Colors.blue),)
          ],
        ) ,
        elevation: 0.0,
      ),
      body: _loading? Center(
        child: Container(
          child: CircularProgressIndicator(

          ),

        ),
      ):SingleChildScrollView(
        child: Container(

            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return CategoryTile(
                          imageUrl:categories[index].imageUrl ,
                          categoryName: categories[index].categoryName,
                        );
                      }),
                ),

                Container(
                    padding: EdgeInsets.only(top: 16),
                    child: ListView.builder(
                    itemCount:article.length ,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder:(context,index){
                      return BlogTile(
                        imageUrl:article[index].urlToImage ,
                        title: article[index].title,
                        desc: article[index].description,
                        url: article[index].url,
                      );
                      })
                )
                ],
            ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {

  final imageUrl, categoryName;

  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context) => CategoryNews(newsCategory: categoryName.toString().toLowerCase(),)));
        
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child:Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl:imageUrl, width: 120,height: 60,fit: BoxFit.cover,)),
            Container(
              alignment: Alignment.center,
              width: 120,height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),

              child: Text(categoryName, style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),),
            )
          ],
        ) ,
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final imageUrl, title, desc, url;
  BlogTile({this.imageUrl, this.title, this.desc, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      } ,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            Text(title, style:TextStyle(
              fontSize: 17
            ) ,),
            SizedBox(height: 8,),
            Text(desc, style: TextStyle(
              color: Colors.black54
            ),)
          ],
        ),
      ),
    );
  }


}

