# Presence – Flutter app (demo data)

Run: `flutter create presence_app`, replace `pubspec.yaml` and `lib/` with these, then `flutter run`.
Demo logins (password 12345678): Student `CS-2041` · Teacher `T-1042` · Admin `HOD-CS` (teacher/admin code: 123456).

## Folder map
lib/
  main.dart                      app start
  core/                          shared by every screen
    theme.dart                   colors, text styles, ThemeData, toast(), confirm()
    widgets.dart                 Screen, AppCard, Pill, StatTile, Seg, AppShell (bottom tabs), go()
    data.dart                    models + Store (all demo data and actions live here)
  features/
    auth/      login, forgot password, face registration, profile menu (sign out)
    teacher/   shell(3 tabs) · rooms_tab -> room_screen -> class_list_screen
                              review_tab -> scan_detail_screen · reports_tab
    student/   shell(3 tabs) · courses_tab -> course_detail_screen · face_id_tab · account_tab -> change_password
    admin/     shell(3 tabs) · overview_tab -> cameras_online / sessions / average / scans
                              rooms_tab -> room_courses -> course_screen (3 tabs) | room_live | room_offline | add_camera
                              audit_tab

## How to read it
1. Start at features/auth/login_screen.dart, then the role's *_shell.dart (it lists the tabs).
2. Open one tab file; screens it opens are called with go(context, SomeScreen()).
3. Each file starts with a one-line comment saying what the screen does.
4. Data and actions (approve scan, mark present, save timing...) are methods on Store in core/data.dart.
