import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable(createToJson: false)
class Activity {
  final int id;
  final int changed;
  final DateTime start;
  final DateTime end;
  final LocatedField title;
  final LocatedField description;
  final Category category;
  final List<Location> locations;
  final Tipo type;
  final List<Paper> papers;
  final List<Pessoa> people;
  final int status;
  final int weight;
  final Addons? addons;
  final int? parent;
  final String event;
  final List<Activity> subActivities = [];

  Activity({
    required this.id,
    required this.changed,
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.category,
    required this.locations,
    required this.type,
    required this.papers,
    required this.people,
    required this.status,
    required this.weight,
    this.addons,
    this.parent,
    required this.event,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

@JsonSerializable()
class Category {
  final int id;
  final LocatedField title;
  final String? color;
  @JsonKey(name: "background-color")
  final String? backgroundColor;

  Category({
    required this.id,
    required this.title,
    required this.color,
    required this.backgroundColor,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@JsonSerializable()
class Location {
  final int id;
  final LocatedField title;
  final int? parent;

  Location({
    required this.id,
    required this.title,
    this.parent,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}

@JsonSerializable()
class Tipo {
  final int id;
  final LocatedField title;

  Tipo({
    required this.id,
    required this.title,
  });

  factory Tipo.fromJson(Map<String, dynamic> json) => _$TipoFromJson(json);
}

@JsonSerializable()
class Paper {
  final int id;
  final String title;
  final List<Autor> authors;

  Paper({
    required this.id,
    required this.title,
    required this.authors,
  });

  factory Paper.fromJson(Map<String, dynamic> json) => _$PaperFromJson(json);
}

@JsonSerializable()
class Autor {
  final String name;
  final String institution;

  Autor({
    required this.name,
    required this.institution,
  });

  factory Autor.fromJson(Map<String, dynamic> json) => _$AutorFromJson(json);
}

@JsonSerializable()
class Pessoa {
  final int id;
  final String? title;
  final String name;
  final String? institution;
  final LocatedField? bio;
  final String? picture;
  final int weight;
  final Papel role;

  Pessoa({
    required this.id,
    this.title,
    required this.name,
    this.institution,
    this.bio,
    this.picture,
    required this.weight,
    required this.role,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) => _$PessoaFromJson(json);
}

@JsonSerializable()
class Papel {
  final int id;
  final LocatedField? title;

  Papel({
    required this.id,
    this.title,
  });

  factory Papel.fromJson(Map<String, dynamic> json) => _$PapelFromJson(json);
}

@JsonSerializable()
class Addons {
  final String? website;
  final String? twitter;
  final String? youtube;

  Addons({
    this.website,
    this.twitter,
    this.youtube,
  });

  factory Addons.fromJson(Map<String, dynamic> json) => _$AddonsFromJson(json);
}

class LocatedField {
  /// Represents the locale that may be present in every located field
  static const String defaultLocale = "pt-br";

  final Map<String, String> _values;
  final String locale;

  LocatedField(this.locale, this._values);

  String get value => _values[locale] ?? _values[defaultLocale]!;

  factory LocatedField.fromJson(Map<String, dynamic> json) {
    assert(json.isNotEmpty);
    assert(json.containsKey(defaultLocale));

    return LocatedField(
      defaultLocale,
      json.cast<String, String>(),
    );
  }

  Map<String, String> toJson() => {locale: value};
}
