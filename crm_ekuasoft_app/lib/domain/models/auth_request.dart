

class AuthRequest {
    AuthRequest({
      required this.db,
      required this.login,
      required this.password
    });

    String db;
    String login;
    String password;

}