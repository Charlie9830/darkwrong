import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/MetadataDescriptor.dart';

class FieldMetadataDescriptors {
  static Map<String, MetadataDescriptor> _commonProperties =
      <String, MetadataDescriptor>{
    "shortValue": MetadataDescriptor(
      propertyName: "shortValue",
      encoding: MetadataEncoding.text,
      friendlyName: "Short value",
      columnWidth: 75.0,
    ),
    "note": MetadataDescriptor(
      propertyName: "note",
      encoding: MetadataEncoding.text,
      friendlyName: "Note",
      columnWidth: 200,
    )
  };

  static Map<String, MetadataDescriptor> custom = <String, MetadataDescriptor>{
    ..._commonProperties
  };

  static Map<String, MetadataDescriptor> position = {
    ..._commonProperties,
  };

  static Map<String, MetadataDescriptor> channel = {
    ..._commonProperties,
  };

  static Map<String, MetadataDescriptor> unitNumber = {
    ..._commonProperties,
  };

  
  static Map<String, MetadataDescriptor> instrumentName = {
    ..._commonProperties,
    "instrumentType": MetadataDescriptor(
      propertyName: "instrumentType",
      encoding: MetadataEncoding.instrumentType,
      friendlyName: "Type",
      columnWidth: 100,
    ),
    "wattage": MetadataDescriptor(
      propertyName: "wattage",
      encoding: MetadataEncoding.number,
      friendlyName: "Wattage",
      columnWidth: 50,
    )
  };
}
