if [ -e .schild_set ]; then
  echo "Schild wurde bereits installiert"
else
  echo "Schild und Abhängigkeiten installieren"
  # benötigte Bibliotheken installieren
  winetricks -q jet40 msls31 riched30 vb6run native_oleaut32 mdac28

  # den odbc Connector installieren.
  wine msiexec /i mysql-connector-odbc-5.3.9-win32.msi /qn

  # schild installieren
  wine SchILDBasisSetup.exe /silent
  wine schild*.exe /silent

  wine prefix32/drive_c/Program\ Files/MySQL/Connector\ ODBC\ 5.3/myodbc-installer.exe -s -a -c2 -n "schild_mysql" -t "DRIVER=MySQL ODBC 5.3 Unicode Driver;SERVER=$SERVER;DATABASE=$DATENBANK;UID=$BENUTZER;PWD=$PASSWORT"

  echo '
  [oledb]
  ; Everything after this line is an OLE DB initstring
  Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data Source=schild_mysql
  ' > /SchILD-NRW/UDL/mysql.UDL

  # Nun die UDL-Datei einbinden
  # Datenquelle und Benutzer/Passwort eingeben:
  cd /SchILD-NRW/UDL
  wine /SchILD-NRW/SchILD_PWCryptneu.exe

  touch .schild_set
fi

wine /SchILD-NRW/SCHILD2000.exe
