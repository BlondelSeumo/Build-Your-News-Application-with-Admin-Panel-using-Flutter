import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/styles.dart';
import 'package:news_admin/widgets/article_preview.dart';
import 'package:news_admin/widgets/cover_widget.dart';
import 'package:provider/provider.dart';
import '../blocs/admin_bloc.dart';
import '../config/config.dart';
import '../models/article.dart';
import '../utils/dialog.dart';

class UpdateContent extends StatefulWidget {

  final Article data;
  UpdateContent({Key key, @required this.data}) : super(key: key);

  @override
  _UpdateContentState createState() => _UpdateContentState();
}

class _UpdateContentState extends State<UpdateContent> {

  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();
  var titleCtrl = TextEditingController();
  var imageUrlCtrl = TextEditingController();
  var sourceCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var youtubeVideoUrlCtrl = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();


  bool uploadStarted = false;
  var _articleData;

  var categorySelection;
  var contentTypeSelection;


  initData (){
    categorySelection = widget.data.category;
    contentTypeSelection = widget.data.contentType;
    titleCtrl.text = widget.data.title;
    descriptionCtrl.text = widget.data.description;
    imageUrlCtrl.text = widget.data.thumbnailImagelUrl;
    sourceCtrl.text = widget.data.sourceUrl ?? '';
    youtubeVideoUrlCtrl.text = widget.data.youtubeVideoUrl ?? '';
  }


  @override
  void initState() {
    initData();
    super.initState();
  }

  




  void handleUpdate() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if(categorySelection == null){
      openDialog(context, 'Select a category first', '');
    }else if(contentTypeSelection == null){
      openDialog(context, 'Select content type', '');
    }else{
      if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ab.userType == 'tester') {
        openDialog(context, 'You are a Tester', 'Only Admin can upload, delete & modify contents');
      } else {
        setState(()=> uploadStarted = true);
        await updateDatabase();
        setState(()=> uploadStarted = false);
        openDialog(context, 'Updated Successfully', '');
          
          
        
      }
    }
    }
  }




  Future updateDatabase() async {
    final DocumentReference ref = firestore.collection('contents').doc(widget.data.timestamp);
    _articleData = {
      'category' : categorySelection,
      'content type' : contentTypeSelection,
      'title' : titleCtrl.text,
      'description' : descriptionCtrl.text,
      'image url' : imageUrlCtrl.text,
      'youtube url' : contentTypeSelection == 'image' ? null : youtubeVideoUrlCtrl.text,
      'source' : sourceCtrl.text == '' ? null : sourceCtrl.text,
      
    };
    await ref.update(_articleData);
  }






  handlePreview() async{
    if(categorySelection == null){
      openDialog(context, 'Select a category first', '');
    }else if(contentTypeSelection == null){
      openDialog(context, 'Select content type', '');
    }else{
      if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await showArticlePreview(
        context, 
        titleCtrl.text, 
        descriptionCtrl.text, 
        imageUrlCtrl.text, 
        widget.data.loves, 
        sourceCtrl.text, 
        widget.data.date,
        categorySelection,
        contentTypeSelection,
        youtubeVideoUrlCtrl.text ?? ''
        
      );
    }
    }

    
  }




  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: CoverWidget(
              widget: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.10,
                  ),
                  Text(
                    'Update Article Details',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    children: [
                      Expanded(child: categoriesDropdown()),
                      SizedBox(width: 20,),
                      Expanded(child: contentTypeDropdown()),

                    ],
                  ),
                  
                  SizedBox(height: 20,),

                  TextFormField(
                    decoration: inputDecoration('Enter Title', 'Title', titleCtrl),
                    controller: titleCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'Value is empty';
                      return null;
                    },
                    
                  ),
                  SizedBox(height: 20,),


                  TextFormField(
                    decoration: inputDecoration('Enter Thumnail Url', 'Thumnail', imageUrlCtrl),
                    controller: imageUrlCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'Value is empty';
                      return null;
                    },
                    
                  ),
                  
                  
                  SizedBox(height: 20,),

                  
                  contentTypeSelection == null || contentTypeSelection == 'image' ? Container()
                  : Column(
                    children: [
                      TextFormField(
                      decoration: inputDecoration('Enter Youtube Url', 'Youtube video Url', youtubeVideoUrlCtrl),
                      controller: youtubeVideoUrlCtrl,
                      validator: (value) {
                      if (value.isEmpty) return 'Value is empty';
                      return null;
                    },
                  ),
                  
                  
                  SizedBox(height: 20,),
                    ],
                  ),


                  TextFormField(
                    decoration: inputDecoration('Enter Source Url (Optional)', 'Source Url (Optional)', sourceCtrl),
                    controller: sourceCtrl,
                  ),
                  
                  
                  SizedBox(height: 20,),


                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter Description (Html or Normal Text)',
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        contentPadding: EdgeInsets.only(
                            right: 0, left: 10, top: 15, bottom: 5),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                                icon: Icon(Icons.close, size: 15),
                                onPressed: () {
                                  descriptionCtrl.clear();
                                }),
                          ),
                        )),
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'Value is empty';
                      return null;
                    },
                    
                  ),

                  SizedBox(height: 100,),


                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          
                          
                          TextButton.icon(
                            
                            icon: Icon(Icons.remove_red_eye, size: 25, color: Colors.blueAccent,),
                            label: Text('Preview', style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                            ),),
                            onPressed: (){
                              handlePreview();
                            }
                          )
                        ],
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      color: Colors.deepPurpleAccent,
                      height: 45,
                      child: uploadStarted == true
                        ? Center(child: Container(height: 30, width: 30,child: CircularProgressIndicator()),)
                        : TextButton(
                          child: Text(
                            'Update Article',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async{
                            handleUpdate();
                            
                          })
                        
                        ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              )),
      ),
      
    );
  }



  Widget categoriesDropdown() {
    final AdminBloc ab = Provider.of(context, listen: false);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                categorySelection = value;
              });
            },
            onSaved: (value) {
              setState(() {
                categorySelection = value;
              });
            },
            value: categorySelection,
            hint: Text('Select Category'),
            items: ab.categories.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }


  Widget contentTypeDropdown() {
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                contentTypeSelection = value;
              });
            },
            onSaved: (value) {
              setState(() {
                contentTypeSelection = value;
              });
            },
            value: contentTypeSelection,
            hint: Text('Select Content Type'),
            items: Config().contentTypes.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }

}
