### Baza Danych dla sytemu komunikacji miejskiej

Jest to prosta baza przygotowana do zarządzania pracownikami, autobusami, liniami komunikacyjnymi oraz rozkładem jazdy autobusów dla każdego dnia.

# Tabele

W bazie znajduje się 10 tabel:
* Addresses (zawierają adresy kierowców)
* Buses 
* Drivers
* Lines
* Line Routes (zawiera trasy wszystkich linii)
* Station (przystanki)
* Schedule (godziny startów poszczególnych linii)
* Licences (licencje kierowców)
* Breakdowns (rodzaje popsuć autobusów)
* Bus Categories (rodzaje autobusów)

# Schemat bazy:
![Diagram](/diagram.png)

# Funkcje oraz procedury składowane bazy

* `add_driver` - dodaje do bazy kierowce wraz z licencją 
* `add_station_to_route` - dodaje przystanek do trasy, także istniejącej, przy braku podania argumentu order_index automatycznie dopisuje przystanek na końcu
* `delete_station_proc` - procedura usuwająca przystanek poprawnie, utrzymuje dobrą kolejność przystanków w lini
* `breakdown_check` - procedura wyświetlająca statystyki popsutych autobusów
* `route_from_a_to_b` - procedura wyświetlająca linie, które mogą bezpośrednio poprowadzić nas z przystanku a do b
* `route_distance` - wyświetla całkowitą długość lini (w czasie przejazdu)
* `is_driver_busy` - zwraca 0, gdy kierowca nie jest zajęty o podanym czasie, 1 w przeciwnym przypadku
* `is_driver_license_active` -  zwraca 0, gdy kierowca ma aktywną licencję, 1 w przeciwnym przypadku
* `schedule_for_station` - wyświetla rozkład jazdy autobusów dla konkretnego przystanku
* `working_hours` - zwraca czas pracy danego kierowcy
* `schedule_for_line` - rozkład jazdy dla konkretnej linii