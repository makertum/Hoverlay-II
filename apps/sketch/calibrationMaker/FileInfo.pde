class FileInfo{
  String path;
  String extension;
  String cleanFileName;
  String fileName;
  String parent;
  String seperator;
  FileInfo(String _path){
    seperator=System.getProperty("file.separator");
    path=_path;
    String[] elements=split(path,seperator);
    if(elements.length>0){
      
      // parsing filename
      fileName=elements[elements.length-1];
      
      // parsing filename and extension
      String[] filements=split(fileName,".");
      if(filements.length==0){
        cleanFileName="";
        extension="";
      }else if(filements.length==1){
        cleanFileName=filements[0];
        extension="";
      }else{
        cleanFileName=filements[0];
        for(int i=1;i<filements.length-1;i++){
          cleanFileName=fileName+"."+filements[i];
        }
        extension=filements[filements.length-1];
      }
      
      //parsing path
      if(elements.length>1){
        elements=(String[])shorten(elements);
        parent=join(elements,seperator);
      }else{
        parent="";
      }
    }
  }
  
  String getModified(String _subfolder, String _prefix, String _suffix, String _extension){
    String output=parent;
    if(!_subfolder.equals("")){
      output=output+seperator+_subfolder;
    }
    output=output+seperator+_prefix+cleanFileName+_suffix;
    if(!_extension.equals("")){
      output=output+"."+_extension;
    }else{
      output=output+"."+extension;
    }
    return output;
  }
  
  String getSubfolder(String _subfolder){
    String output=parent;
    if(!_subfolder.equals("")){
      output=output+seperator+_subfolder;
    }
    return output;
  }
}
