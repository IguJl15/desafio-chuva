// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as int,
      changed: json['changed'] as int,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      title: LocatedField.fromJson(json['title'] as Map<String, dynamic>),
      description:
          LocatedField.fromJson(json['description'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: Tipo.fromJson(json['type'] as Map<String, dynamic>),
      papers: (json['papers'] as List<dynamic>)
          .map((e) => Paper.fromJson(e as Map<String, dynamic>))
          .toList(),
      people: (json['people'] as List<dynamic>)
          .map((e) => Pessoa.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int,
      weight: json['weight'] as int,
      addons: json['addons'] == null
          ? null
          : Addons.fromJson(json['addons'] as Map<String, dynamic>),
      parent: json['parent'] as int?,
      event: json['event'] as String,
    );

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int,
      title: LocatedField.fromJson(json['title'] as Map<String, dynamic>),
      color: json['color'] as String?,
      backgroundColor: json['background-color'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'background-color': instance.backgroundColor,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: json['id'] as int,
      title: LocatedField.fromJson(json['title'] as Map<String, dynamic>),
      parent: json['parent'] as int?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'parent': instance.parent,
    };

Tipo _$TipoFromJson(Map<String, dynamic> json) => Tipo(
      id: json['id'] as int,
      title: LocatedField.fromJson(json['title'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TipoToJson(Tipo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

Paper _$PaperFromJson(Map<String, dynamic> json) => Paper(
      id: json['id'] as int,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => Autor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaperToJson(Paper instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
    };

Autor _$AutorFromJson(Map<String, dynamic> json) => Autor(
      name: json['name'] as String,
      institution: json['institution'] as String,
    );

Map<String, dynamic> _$AutorToJson(Autor instance) => <String, dynamic>{
      'name': instance.name,
      'institution': instance.institution,
    };

Pessoa _$PessoaFromJson(Map<String, dynamic> json) => Pessoa(
      id: json['id'] as int,
      title: json['title'] as String?,
      name: json['name'] as String,
      institution: json['institution'] as String?,
      bio: json['bio'] == null
          ? null
          : LocatedField.fromJson(json['bio'] as Map<String, dynamic>),
      picture: json['picture'] as String?,
      weight: json['weight'] as int,
      role: Papel.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PessoaToJson(Pessoa instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'institution': instance.institution,
      'bio': instance.bio,
      'picture': instance.picture,
      'weight': instance.weight,
      'role': instance.role,
    };

Papel _$PapelFromJson(Map<String, dynamic> json) => Papel(
      id: json['id'] as int,
      title: json['title'] == null
          ? null
          : LocatedField.fromJson(json['title'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PapelToJson(Papel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

Addons _$AddonsFromJson(Map<String, dynamic> json) => Addons(
      website: json['website'] as String?,
      twitter: json['twitter'] as String?,
      youtube: json['youtube'] as String?,
    );

Map<String, dynamic> _$AddonsToJson(Addons instance) => <String, dynamic>{
      'website': instance.website,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
    };
