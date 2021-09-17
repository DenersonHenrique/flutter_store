class AuthException implements Exception {
  final String key;

  const AuthException(this.key);

  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail utilizando por outra conta.",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Falha na autenticação.",
    "EMAIL_NOT_FOUND": "E-mail não encontrado",
    "INVALID_PASSWORD": "Senha inválida.",
    "USER_DISABLED": "Usuário desativado.",
  };

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro durante atenticação';
  }
}
