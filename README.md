# Lab 1: DDD & Weryfikacja danych wejściowych - iOS Edition

> **Autor:** Michał Fereniec  
> **Data:** 29 stycznia 2026  
> **Temat:** Tworzenie bezpiecznego oprogramowania  

---

## 🎯 Cel projektu

Implementacja aplikacji iOS demonstrującej:
1. Zasady **Domain Driven Design** (DDD)
2. Walidację danych wejściowych na poziomie domeny
3. Ochronę przed atakami **XSS** (Cross-Site Scripting)
4. **Unit testing** walidatora

---

## 📋 Punktacja zadania (0-5 + bonus)

| Kryterium | Punkty | Status | Ścieżka w projekcie |
|-----------|--------|--------|---------------------|
| **1. Domain Driven Design** (DDD.md) | 1 pkt | ✅ | `DDD.md` |
| **2. Udokumentowanie XSS** | 1 pkt | ✅ | Ten README (sekcja poniżej) |
| **3. Implementacja poprawki** | 2 pkt | ✅ | `Lab1-iOS/Domain/CredentialsValidator.swift` |
| **4. Poprawny Pull Request** | 1 pkt | ✅ | Struktura + commits + opis |
| **5. Test jednostkowy walidatora** | +1 BONUS | ✅ | `Lab1-iOSTests/Lab1_iOSTests.swift` |
| **SUMA** | **6/5** | 🏆 | **Przekroczenie progu** |

---

## 🔐 Udokumentowanie podatności XSS

### Typ podatności
**Persistent (Stored) XSS** – złośliwy kod JavaScript/HTML wstrzykiwany przez użytkownika mógłby zostać zapisany w systemie i wykonany przy każdym wyświetleniu danych.

### Miejsce wystąpienia
- **Ekran logowania** (`ContentView.swift`)
- **Pola wejściowe:** 
  - Username (TextField)
  - Password (SecureField / TextField z togglem widoczności)

### Sposób odtworzenia

1. Uruchom aplikację Lab1-iOS
2. W polu **Login** wprowadź: