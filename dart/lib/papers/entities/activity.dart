class Activity {
  final int id;
  final int changed;
  final String start;
  final String end;
  final LocatedString title;
  final LocatedString description;
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

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      changed: json['changed'],
      start: json['start'],
      end: json['end'],
      title: LocatedString.fromJson(json['title']),
      description: LocatedString.fromJson(json['description']),
      category: Category.fromJson(json['category']),
      locations: List<Location>.from(json['locations'].map((dynamic l) => Location.fromJson(l))),
      type: Tipo.fromJson(json['type']),
      papers: List<Paper>.from(json['papers'].map((dynamic p) => Paper.fromJson(p))),
      people: List<Pessoa>.from(json['people'].map((dynamic p) => Pessoa.fromJson(p))),
      status: json['status'],
      weight: json['weight'],
      addons: json['addons'] != null ? Addons.fromJson(json['addons']) : null,
      parent: json['parent'],
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'changed': changed,
        'start': start,
        'end': end,
        'title': title.toJson(),
        'description': description.toJson(),
        'category': category.toJson(),
        'locations': locations.map((l) => l.toJson()).toList(),
        'type': type.toJson(),
        'papers': papers.map((p) => p.toJson()).toList(),
        'people': people.map((p) => p.toJson()).toList(),
        'status': status,
        'weight': weight,
        'addons': addons?.toJson(),
        'parent': parent,
        'event': event,
      };
}

class Category {
  final int id;
  final LocatedField title;
  final String color;
  final String backgroundColor;

  Category({
    required this.id,
    required this.title,
    required this.color,
    required this.backgroundColor,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: LocatedField.fromJson(json['title']),
      color: json['color'],
      backgroundColor: json['background-color'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'color': color,
        'background-color': backgroundColor,
      };
}

class Location {
  final int id;
  final LocatedField title;
  final int? parent;

  Location({
    required this.id,
    required this.title,
    this.parent,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      title: LocatedField.fromJson(json['title']),
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'parent': parent,
      };
}

class Tipo {
  final int id;
  final LocatedField title;

  Tipo({
    required this.id,
    required this.title,
  });

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      id: json['id'],
      title: LocatedField.fromJson(json['title']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
      };
}

class Paper {
  final int id;
  final String title;
  final List<Autor> authors;

  Paper({
    required this.id,
    required this.title,
    required this.authors,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'],
      title: json['title'],
      authors: List<Autor>.from(json['authors'].map((dynamic a) => Autor.fromJson(a))),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors.map((a) => a.toJson()).toList(),
      };
}

class Autor {
  final String name;
  final String institution;

  Autor({
    required this.name,
    required this.institution,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      name: json['name'],
      institution: json['institution'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'institution': institution,
      };
}

class Pessoa {
  final int id;
  final String? title;
  final String name;
  final String? institution;
  final String? bio;
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

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      institution: json['institution'],
      bio: json['bio'],
      picture: json['picture'],
      weight: json['weight'],
      role: Papel.fromJson(json['role']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'name': name,
        'institution': institution,
        'bio': bio,
        'picture': picture,
        'weight': weight,
        'role': role.toJson(),
      };
}

class Papel {
  final int id;
  final LocatedField title;

  Papel({
    required this.id,
    required this.title,
  });

  factory Papel.fromJson(Map<String, dynamic> json) {
    return Papel(
      id: json['id'],
      title: LocatedField.fromJson(json['title']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
      };
}

class Addons {
  final String? website;
  final String? twitter;
  final String? youtube;

  Addons({
    this.website,
    this.twitter,
    this.youtube,
  });

  factory Addons.fromJson(Map<String, dynamic> json) {
    return Addons(
      website: json['website'],
      twitter: json['twitter'],
      youtube: json['youtube'],
    );
  }

  Map<String, dynamic> toJson() => {
        'website': website,
        'twitter': twitter,
        'youtube': youtube,
      };
}

typedef LocatedString = LocatedField<String>;

class LocatedField<T> {
  /// Represents the locale that may be present in every located field
  static const String defaultLocale = "pt-br";

  final Map<String, T> _values;
  final String locale;

  LocatedField(this.locale, this._values);

  T get value => _values[locale] ?? _values[defaultLocale]!;

  factory LocatedField.fromJson(Map<String, dynamic> json,
      [String locale = defaultLocale, T Function(dynamic)? mapFn]) {
    assert(json.isNotEmpty);
    assert(json.containsKey(defaultLocale));

    return LocatedField(
      locale,
      mapFn != null //
          ? json.map((key, value) => MapEntry(key, mapFn(value)))
          : json as Map<String, T>,
    );
  }

  Map<String, dynamic> toJson() => {locale: value};
}
