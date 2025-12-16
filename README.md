# To-Do App (Full-stack Dart) 📝

Nowoczesna aplikacja do zarządzania zadaniami zbudowana w oparciu o architekturę **Full-stack Dart**. Projekt wykorzystuje potężny backend **Serverpod**, relacyjną bazę danych **PostgreSQL** oraz zaawansowane zarządzanie stanem po stronie klienta za pomocą biblioteki **BLoC**.

---

## 🏗 Architektura systemu

Projekt został zaprojektowany zgodnie z zasadami czystej architektury (Clean Architecture), co zapewnia skalowalność i łatwość utrzymania kodu:

* **Backend (Serverpod):** Skalowany serwer napisany w języku Dart, obsługujący logikę biznesową i komunikację z bazą danych.
* **Database (PostgreSQL):** Profesjonalna, relacyjna baza danych zapewniająca trwałość i bezpieczeństwo danych.
* **State Management (BLoC):** Warstwa prezentacji oddzielona od logiki biznesowej za pomocą wzorca **Business Logic Component**, co gwarantuje reaktywne i przewidywalne UI.
* **Shared Models:** Automatyczna synchronizacja modeli danych między serwerem a klientem, eliminująca błędy w komunikacji API.

## 🛠 Stos technologiczny

* **Frontend:** [Flutter](https://flutter.dev/)
* **Backend:** [Serverpod](https://serverpod.dev/)
* **Baza danych:** [PostgreSQL](https://www.postgresql.org/)
* **Zarządzanie stanem:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc)
* **Infrastruktura:** Docker (konteneryzacja bazy danych)

## 🚀 Funkcje

* **Pełny CRUD:** Dodawanie, edycja, usuwanie i pobieranie zadań z serwera.
* **Real-time sync:** Synchronizacja danych między wieloma urządzeniami.
* **Statusy zadań:** Możliwość oznaczania zadań jako ukończone.
* **Solidna architektura:** Kod przygotowany pod testy jednostkowe i integracyjne.

## ⚙️ Jak uruchomić projekt?

Aby uruchomić aplikację lokalnie, wykonaj poniższe kroki w podanej kolejności:

### 1. Baza danych (Docker)
Wymagany jest zainstalowany Docker. Uruchom bazę danych PostgreSQL:
```bash
cd todo_app_server
docker-compose up -d
```

### 2. Serwer Serverpod
Gdy kontenery z bazą danych wystartują, uruchom serwer:
```Bash
# W katalogu todo_app_server
dart bin/main.dart
```

### 3. Aplikacja Flutter (Klient)
```bash
cd todo_app_flutter
flutter run
```

## 📁 Struktura repozytorium
* **todo_app_server:** Warstwa backendowa (modele .yaml, logika API).

* **todo_app_client:** Wygenerowany kod klienta (most łączący Fluttera z serwerem).

* **todo_app_flutter:** Aplikacja mobilna z implementacją BLoC i UI.

---
👤 **Autor**
* GitHub: [@lukcza](https://github.com/lukcza)
