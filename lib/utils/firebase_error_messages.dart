class FirebaseErrorMessages {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'Böyle bir kullanıcı bulunamadı. Lütfen tekrar deneyin.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-disabled':
        return 'Bu kullanıcı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor.';
      case 'operation-not-allowed':
        return 'Bu operasyon yapılamaz.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
