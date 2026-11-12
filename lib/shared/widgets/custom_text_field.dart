import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır

class CustomTextField extends StatelessWidget { // Durumsuz (Stateless) CustomTextField görsel bileşenini tanımlar
  final TextEditingController controller; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? hint; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final IconData? prefixIcon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Widget? suffixIcon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool obscureText; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final TextInputType keyboardType; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? Function(String?)? validator; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final TextInputAction? textInputAction; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final void Function(String)? onFieldSubmitted; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const CustomTextField({ // Kullanıcıdan metin girdisi alan form alanını oluşturur
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.controller, // controller parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.hint, // hint sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.prefixIcon, // prefixIcon sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.suffixIcon, // suffixIcon sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.obscureText = false, // obscureText = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.keyboardType = TextInputType.text, // keyboardType = TextInputType.text sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.validator, // validator sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.textInputAction, // textInputAction sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.onFieldSubmitted, // onFieldSubmitted sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    return TextFormField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
      controller: controller, // controller özelliğini yapılandırır
      obscureText: obscureText, // obscureText özelliğini yapılandırır
      keyboardType: keyboardType, // keyboardType özelliğini yapılandırır
      validator: validator, // validator özelliğini yapılandırır
      textInputAction: textInputAction, // textInputAction özelliğini yapılandırır
      onFieldSubmitted: onFieldSubmitted, // onFieldSubmitted özelliğini yapılandırır
      decoration: InputDecoration( // İlgili kod satırını ve işlemi yürütür
        labelText: label, // labelText özelliğini yapılandırır
        hintText: hint, // hintText özelliğini yapılandırır
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null, // Ekranda vektörel ikon gösterir
        suffixIcon: suffixIcon, // suffixIcon özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

