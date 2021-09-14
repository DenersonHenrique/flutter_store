class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail utilizando por outra conta.",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Falha na autenticação.",
    "EMAIL_NOT_FOUND": "E-mail não encontrado",
    "INVALID_PASSWORD": "Senha inválida.",
    "USER_DISABLED": "Usuário desativado.",
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    return errors.containsKey(key)
        ? errors[key]
        : 'Ocorreu um erro durante atenticação';
  }
}
