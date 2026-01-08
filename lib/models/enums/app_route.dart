enum AppRoute {
  splash('/splash'),
  onboarding('/onboarding'),
  login('/login'),
  join('/join'),
  joinApple('/join-apple'),
  registerParent('/register-parent'),
  welcome('/welcome'),
  integrate('/integrate'),

  findEmail('/find-email'),
  findPassword('/find-password'),

  home('/home'),

  /* 목표 */
  goal('/goal'),
  walk('walk'),
  medicine('medicine'),
  walkEdit('/walk-edit'),

  location('/location'),
  album('/album'),
  user('/user'),

  searchAddress('/search-address'),
  uploadPhoto('/upload-photo'),
  createPost('/create-post'),
  ;

  final String path;
  const AppRoute(this.path);
}
