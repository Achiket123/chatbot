import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';

const boxName = 'NAME3';
const userData = 'HISTORY';
const userImage = 'IMAGE';

ChatMedia media = ChatMedia(url: '', mediaType: MediaType.imageMediaType());

void main() {
  var a = media.mediaType;
  print(a);
}
