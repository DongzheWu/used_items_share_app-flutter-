
// Create path for firebase url
class Path{
  static String itemInfo(String uid, String itemId) => 'users/$uid/jobs/$itemId';
  static String itemInfos(String uid) => 'users/$uid/jobs';
}