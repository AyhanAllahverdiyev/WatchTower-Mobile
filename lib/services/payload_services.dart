import 'dart:ffi';

List<String> updatedAuthLevelList = [];
List<String> _updatedAuthLevelList = [];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PayloadServices {
  String decodedResultPayload(List<int> intArray) {
    // Map each integer to its corresponding character and join them into a string
    String decodedString = String.fromCharCodes(intArray);

    if (decodedString.contains("}") && decodedString.contains("{")) {
      int indexOfBeginning = decodedString.indexOf('{');
      int indexOfEnd = decodedString.lastIndexOf('}');
      String fullCleanResult =
          decodedString.substring(indexOfBeginning, indexOfEnd + 1);
      return fullCleanResult;
    } else {
      return decodedString;
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<int> convertStringToArray(String arrayString) {
    List<int> intList = arrayString.split(',').map(int.parse).toList();
    return intList;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  String getPayload(String jsonString) {
    try {
      int payloadIndex = jsonString.indexOf('payload');

      if (payloadIndex == -1) {
        print('Error: "payload"  not found.');
      }

      int startIndex = jsonString.indexOf('[', payloadIndex);

      int endIndex = jsonString.indexOf(']', startIndex);

      String payloadSubstring = jsonString.substring(startIndex + 1, endIndex);

      return payloadSubstring;
    } catch (e) {
      print('Error parsing JSON: $e');
      return "";
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void addToUpdatedAuthLevelList(String id, String auth_level) {
    _updatedAuthLevelList.add('{"_id": "$id","auth_level": "$auth_level"}');
  }

  List<String> getUpdatedAuthLevelList() {
    setUpdatedAuthLevelList(_updatedAuthLevelList);
    print('======================USER LIST======================');
    print('updatedAuthLevelList: $updatedAuthLevelList');
    return updatedAuthLevelList;
  }

  void setUpdatedAuthLevelList(List<String> list) {
    updatedAuthLevelList = list;
  }

  void clearUpdatedAuthLevelList() {
    updatedAuthLevelList.clear();
    _updatedAuthLevelList.clear();
  }
}
