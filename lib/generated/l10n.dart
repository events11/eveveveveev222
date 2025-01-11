// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get Login {
    return Intl.message(
      'Log in',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get Guest {
    return Intl.message(
      'Guest',
      name: 'Guest',
      desc: '',
      args: [],
    );
  }

  /// `change Language`
  String get changeLanguageButton {
    return Intl.message(
      'change Language',
      name: 'changeLanguageButton',
      desc: '',
      args: [],
    );
  }

  /// `HomePage`
  String get homePage {
    return Intl.message(
      'HomePage',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `What is the event...`
  String get Writeyourpost {
    return Intl.message(
      'What is the event...',
      name: 'Writeyourpost',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get home {
    return Intl.message(
      '',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `person`
  String get person {
    return Intl.message(
      'person',
      name: 'person',
      desc: '',
      args: [],
    );
  }

  /// `No new notifications .`
  String get Noewnotifications {
    return Intl.message(
      'No new notifications .',
      name: 'Noewnotifications',
      desc: '',
      args: [],
    );
  }

  /// `Create a post`
  String get Createapost {
    return Intl.message(
      'Create a post',
      name: 'Createapost',
      desc: '',
      args: [],
    );
  }

  /// ` ? Text`
  String get Text {
    return Intl.message(
      ' ? Text',
      name: 'Text',
      desc: '',
      args: [],
    );
  }

  /// `Add a location (optional)`
  String get Addalocation {
    return Intl.message(
      'Add a location (optional)',
      name: 'Addalocation',
      desc: '',
      args: [],
    );
  }

  /// `Time and Date for the event (optional)`
  String get Timeanddate {
    return Intl.message(
      'Time and Date for the event (optional)',
      name: 'Timeanddate',
      desc: '',
      args: [],
    );
  }

  /// `Share the post`
  String get Sharethepost {
    return Intl.message(
      'Share the post',
      name: 'Sharethepost',
      desc: '',
      args: [],
    );
  }

  /// `Add photo/video`
  String get Addphotovideo {
    return Intl.message(
      'Add photo/video',
      name: 'Addphotovideo',
      desc: '',
      args: [],
    );
  }

  /// `picture selection`
  String get Chooseapictur {
    return Intl.message(
      'picture selection',
      name: 'Chooseapictur',
      desc: '',
      args: [],
    );
  }

  /// `Video selection`
  String get Videoselection {
    return Intl.message(
      'Video selection',
      name: 'Videoselection',
      desc: '',
      args: [],
    );
  }

  /// `Message Box`
  String get messagebox {
    return Intl.message(
      'Message Box',
      name: 'messagebox',
      desc: '',
      args: [],
    );
  }

  /// `Members List`
  String get MembersList {
    return Intl.message(
      'Members List',
      name: 'MembersList',
      desc: '',
      args: [],
    );
  }

  /// `Add a member`
  String get Addamember {
    return Intl.message(
      'Add a member',
      name: 'Addamember',
      desc: '',
      args: [],
    );
  }

  /// `Save edits`
  String get Saveedits {
    return Intl.message(
      'Save edits',
      name: 'Saveedits',
      desc: '',
      args: [],
    );
  }

  /// `No CV`
  String get NoCV {
    return Intl.message(
      'No CV',
      name: 'NoCV',
      desc: '',
      args: [],
    );
  }

  /// `Edit CV`
  String get EditCV {
    return Intl.message(
      'Edit CV',
      name: 'EditCV',
      desc: '',
      args: [],
    );
  }

  /// `Name not available`
  String get Namenotavailable {
    return Intl.message(
      'Name not available',
      name: 'Namenotavailable',
      desc: '',
      args: [],
    );
  }

  /// `Your Posts`
  String get YourPosts {
    return Intl.message(
      'Your Posts',
      name: 'YourPosts',
      desc: '',
      args: [],
    );
  }

  /// `No posts.`
  String get Noposts {
    return Intl.message(
      'No posts.',
      name: 'Noposts',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable content`
  String get Unavailablecontent {
    return Intl.message(
      'Unavailable content',
      name: 'Unavailablecontent',
      desc: '',
      args: [],
    );
  }

  /// `Modify name`
  String get Modifyname {
    return Intl.message(
      'Modify name',
      name: 'Modifyname',
      desc: '',
      args: [],
    );
  }

  /// `Member has been added successfully`
  String get Memberhasbeenaddedsuccessfully {
    return Intl.message(
      'Member has been added successfully',
      name: 'Memberhasbeenaddedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The post was deleted successfully`
  String get Thepostwasdeletedsuccessfully {
    return Intl.message(
      'The post was deleted successfully',
      name: 'Thepostwasdeletedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Send Invitation`
  String get SendInvitation {
    return Intl.message(
      'Send Invitation',
      name: 'SendInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Send to All `
  String get SendtoAll {
    return Intl.message(
      'Send to All ',
      name: 'SendtoAll',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get Send {
    return Intl.message(
      'Send',
      name: 'Send',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get Writeyourmessagehere {
    return Intl.message(
      'Write your message here...',
      name: 'Writeyourmessagehere',
      desc: '',
      args: [],
    );
  }

  /// `Select Post`
  String get SelectPost {
    return Intl.message(
      'Select Post',
      name: 'SelectPost',
      desc: '',
      args: [],
    );
  }

  /// `Select Receiver`
  String get SelectReceiver {
    return Intl.message(
      'Select Receiver',
      name: 'SelectReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Personal Events`
  String get PersonalEvents {
    return Intl.message(
      'Personal Events',
      name: 'PersonalEvents',
      desc: '',
      args: [],
    );
  }

  /// `Public Events`
  String get PublicEvents {
    return Intl.message(
      'Public Events',
      name: 'PublicEvents',
      desc: '',
      args: [],
    );
  }

  /// `Organizational Events`
  String get OrganizationalEvents {
    return Intl.message(
      'Organizational Events',
      name: 'OrganizationalEvents',
      desc: '',
      args: [],
    );
  }

  /// `Recreational Events`
  String get RecreationalEvents {
    return Intl.message(
      'Recreational Events',
      name: 'RecreationalEvents',
      desc: '',
      args: [],
    );
  }

  /// `All Events`
  String get AllEvents {
    return Intl.message(
      'All Events',
      name: 'AllEvents',
      desc: '',
      args: [],
    );
  }

  /// `? Title`
  String get Title {
    return Intl.message(
      '? Title',
      name: 'Title',
      desc: '',
      args: [],
    );
  }

  /// `Set Rules and Ticket Price (Optional)`
  String get SetRulesandTicketPrice {
    return Intl.message(
      'Set Rules and Ticket Price (Optional)',
      name: 'SetRulesandTicketPrice',
      desc: '',
      args: [],
    );
  }

  /// `Select Event Type`
  String get SelectEventType {
    return Intl.message(
      'Select Event Type',
      name: 'SelectEventType',
      desc: '',
      args: [],
    );
  }

  /// `The post has been published successfully!`
  String get Theposthasbeenpublishedsuccessfully {
    return Intl.message(
      'The post has been published successfully!',
      name: 'Theposthasbeenpublishedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please enter text or add a file or location  .`
  String get Pleaseenter {
    return Intl.message(
      'Please enter text or add a file or location  .',
      name: 'Pleaseenter',
      desc: '',
      args: [],
    );
  }

  /// `Post Details`
  String get PostDetails {
    return Intl.message(
      'Post Details',
      name: 'PostDetails',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
