abstract class DocumentInterface {
  String compact(String document);
  String validate(String document);
  bool isValid(String document);
  String format(String document);
}
