import re
# noinspection PyUnresolvedReferences
import os
# noinspection PyUnresolvedReferences
import smtplib
# noinspection PyUnresolvedReferences
from email.mime.text import MIMEText

# Główny kod
folder_path = 'D:\Skrypt VIVID IQ\pliki źródłowe'
opisy_folder_path = 'D:\Skrypt VIVID IQ\opisy'

# Pobranie listy plików w folderze "pliki źródłowe"
files = os.listdir(folder_path)
file_name = ''  # Domyślna pusta wartość
print("Lista plików w folderze:")
print(files)
# Iteracja po plikach
for file_name in files:
    # Sprawdzenie, czy plik jest plikiem tekstowym
    if file_name.endswith('.txt'):
        file_path = os.path.join(folder_path, file_name)

        # Przetwarzanie pliku
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()

        # Wyszukanie danych pacjenta
        name_match = re.search(r'Name\s+(.*)', text)
        name = name_match.group(1) if name_match else ''

        patient_id_match = re.search(r'Patient Id\s+(.*)', text)
        patient_id = patient_id_match.group(1) if patient_id_match else ''




        weight_match = re.search(r'Weight\s+(.*)', text)
        weight = weight_match.group(1) if weight_match else ''



        exam_date_match = re.search(r'Date\s+(.*)', text)
        exam_date = exam_date_match.group(1) if exam_date_match else ''

        bsa_match = re.search(r'BSA\s+(.*)', text)
        bsa = bsa_match.group(1) if bsa_match else ''

        name = name.strip()
        patient_id = patient_id.strip()
        exam_date = exam_date.strip()
        weight = weight.strip()
        bsa = bsa.strip()
        # Wyszukanie poszczególnych wartości za pomocą wyrażeń regularnych
        ao_diam_aorta_match = re.search(r'Ao Diam\s+(.*)', text)
        ao_diam_aorta = ao_diam_aorta_match.group(1) if ao_diam_aorta_match else ''

        la_diam_left = ''
        la_diam = ''

        la_diam_match = re.finditer(r'LA Diam\s+(.*)', text)
        for match in la_diam_match:
            value = match.group(1)
            if not la_diam_left:
                la_diam_left = value
            else:
                la_diam = value
                break

        la_aod_match = re.search(r'LA/Ao\s+(.*)', text)
        la_aod = la_aod_match.group(1) if la_aod_match else ''

        la_aod2_match = re.search(r'LA/AOD\s+(.*)', text)
        la_aod2 = la_aod2_match.group(1) if la_aod2_match else ''

        ladnorm_match = re.search(r'LADnorm\s+(.*)', text)
        ladnorm = ladnorm_match.group(1) if ladnorm_match else ''

        ladaolx_match = re.search(r'LAD/AoLx\s+(.*)', text)
        lad_aolx = ladaolx_match.group(1) if ladaolx_match else ''

        lvld_a2c_match = re.search(r'LVLd A2C\s+(.*)', text)
        lvld_a2c = lvld_a2c_match.group(1) if lvld_a2c_match else ''

        lvedv_mod_a2c_match = re.search(r'LVEDV MOD A2C\s+(.*)', text)
        lvedv_mod_a2c = lvedv_mod_a2c_match.group(1) if lvedv_mod_a2c_match else ''

        lvedv_kg_match = re.search(r'LVEDV\\KG\s+(.*)', text)
        lvedv_kg = lvedv_kg_match.group(1) if lvedv_kg_match else ''

        lvls_a2c_match = re.search(r'LVLs A2C\s+(.*)', text)
        lvls_a2c = lvls_a2c_match.group(1) if lvls_a2c_match else ''

        lvesv_mod_a2c_match = re.search(r'LVESV MOD A2C\s+(.*)', text)
        lvesv_mod_a2c = lvesv_mod_a2c_match.group(1) if lvesv_mod_a2c_match else ''

        lvesv_kg_match = re.search(r'LVESV/KG\s+(.*)', text)
        lvesv_kg = lvesv_kg_match.group(1) if lvesv_kg_match else ''

        lvef_mod_a2c_match = re.search(r'LVEF MOD A2C\s+(.*)', text)
        lvef_mod_a2c = lvef_mod_a2c_match.group(1) if lvef_mod_a2c_match else ''

        sv_mod_a2c_match = re.search(r'SV MOD A2C\s+(.*)', text)
        sv_mod_a2c = sv_mod_a2c_match.group(1) if sv_mod_a2c_match else ''

        co_mod_a2c_match = re.search(r'CO MOD A2C\s+(.*)', text)
        co_mod_a2c = co_mod_a2c_match.group(1) if co_mod_a2c_match else ''

        rvidd_match = re.search(r'RVIDd\s+(.*)', text)
        rvidd = rvidd_match.group(1) if rvidd_match else ''

        rvids_match = re.search(r'RVIDs\s+(.*)', text)
        rvids = rvids_match.group(1) if rvids_match else ''

        ivsd_match = re.search(r'IVSd\s+(.*)', text)
        ivsd = ivsd_match.group(1) if ivsd_match else ''

        lvidd_match = re.search(r'LVIDd\s+(.*)', text)
        lvidd = lvidd_match.group(1) if lvidd_match else ''

        lvpwd_match = re.search(r'LVPWd\s+(.*)', text)
        lvpwd = lvpwd_match.group(1) if lvpwd_match else ''

        ivss_match = re.search(r'IVSs\s+(.*)', text)
        ivss = ivss_match.group(1) if ivss_match else ''

        lvids_match = re.search(r'LVIDs\s+(.*)', text)
        lvids = lvids_match.group(1) if lvids_match else ''

        lvpws_match = re.search(r'LVPWs\s+(.*)', text)
        lvpws = lvpws_match.group(1) if lvpws_match else ''

        fs_match = re.search(r'%FS\s+(.*)', text)
        fs = fs_match.group(1) if fs_match else ''

        lviddn_match = re.search(r'LVID[Dd]N\s+(.*)', text)
        lviddn = lviddn_match.group(1) if lviddn_match else ''

        lvidsn_match = re.search(r'LVID[Ss]N\s+(.*)', text)
        lvidsn = lvidsn_match.group(1) if lvidsn_match else ''

        mv_e_vel_match = re.search(r'MV E Vel\s+(.*)', text)
        mv_e_vel = mv_e_vel_match.group(1) if mv_e_vel_match else ''

        mv_a_vel_match = re.search(r'MV A Vel\s+(.*)', text)
        mv_a_vel = mv_a_vel_match.group(1) if mv_a_vel_match else ''

        mv_ea_ratio_match = re.search(r'MV E/A Ratio\s+(.*)', text)
        mv_ea_ratio = mv_ea_ratio_match.group(1) if mv_ea_ratio_match else ''

        lvot_vmax_match = re.search(r'LVOT Vmax\s+(.*)', text)
        lvot_vmax = lvot_vmax_match.group(1) if lvot_vmax_match else ''

        lvot_maxpg_match = re.search(r'LVOT maxPG\s+(.*)', text)
        lvot_maxpg = lvot_maxpg_match.group(1) if lvot_maxpg_match else ''

        rvot_vmax_match = re.search(r'RVOT Vmax\s+(.*)', text)
        rvot_vmax = rvot_vmax_match.group(1) if rvot_vmax_match else ''

        rvot_maxpg_match = re.search(r'RVOT maxPG\s+(.*)', text)
        rvot_maxpg = rvot_maxpg_match.group(1) if rvot_maxpg_match else ''

        time_match = re.search(r'Time\s+(.*)', text)
        time = time_match.group(1) if time_match else ''

        hr_match = re.search(r'HR\s+(.*)', text)
        hr = hr_match.group(1) if hr_match else ''

        # Przygotowanie sformatowanego tekstu wynikowego
        output = "Dane pacjenta:\n"
        output += "Imię i nazwisko: {}\n".format(name) if name else ""
        output += "ID pacjenta: {}\n".format(patient_id) if patient_id else ""
        output += "Data badania: {}\n".format(exam_date) if exam_date else ""
        output += "Waga: {}\n".format(weight) if weight else ""
        output += "BSA: {}\n".format(bsa) if bsa else ""
        output += "\nBadanie kliniczne: Osłuchowo szmery oddechowe prawidłowe. Serce osłuchowo bez zmian. Brzuch napięty, niebolesny.\n\n"
        output += "BADANIE EKG: rytm miarowy, zatokowy 140-180/min (tachykardia wywołana stresem), w momencie spadku częstotliwości pracy serca widoczna arytmia zatokowa\n\n"
        output += "Badanie echokardiograficzne:\n"
        output += "2-D\nAo Diam aorta = {}\n".format(ao_diam_aorta) if ao_diam_aorta else ""
        output += "LA Diam lewy przedsionek = {}\n".format(la_diam_left) if la_diam_left else ""
        output += "LA/Ao = {}\n".format(la_aod) if la_aod else ""
        output += "LA Diam = {}\n".format(la_diam) if la_diam else ""
        output += "LADnorm = {}\n".format(ladnorm) if ladnorm else ""
        output += "LA/AOD = {}\n".format(la_aod2) if la_aod2 else ""
        output += "\nPomiary SMOD objętości lewej komory\n"
        output += "Projekcja przymostkowa prawostronna w osi długiej PLAX:\n"
        output += "LAD/AoLx Indeks długości przegrody międzykomorowej do średnicy aorty = {}\n".format(
            lad_aolx) if lad_aolx else ""
        output += "LVLd A2C Wymiar dystalny lewej komory w projekcji = {}\n".format(lvld_a2c) if lvld_a2c else ""
        output += "LVEDV MOD = {}\n".format(
            lvedv_mod_a2c) if lvedv_mod_a2c else ""
        output += "LVEDV/KG Objętość skurczowa lewej komory na kilogram masy ciała = {}\n".format(
            lvedv_kg) if lvedv_kg else ""
        output += "LVLs A2C Wymiar skurczowy lewej komory w projekcji A2C = {}\n".format(lvls_a2c) if lvls_a2c else ""
        output += "LVESV MOD  = {}\n".format(
            lvesv_mod_a2c) if lvesv_mod_a2c else ""
        output += "HR Częstość rytmu serca = {}\n".format(hr) if hr else ""
        output += "LVESV/KG Objętość skurczowa lewej komory na kilogram masy ciała = {}\n".format(
            lvesv_kg) if lvesv_kg else ""
        output += "LVEF MOD Frakcja wyrzutowa lewej komory w projekcji PLAX = {}\n".format(
            lvef_mod_a2c) if lvef_mod_a2c else ""
        output += "SV MOD A2C Objętość wyrzutowa serca w projekcji A2C = {}\n".format(sv_mod_a2c) if sv_mod_a2c else ""
        output += "CO MOD A2C Objętość minutowa serca w projekcji A2C = {}\n".format(co_mod_a2c) if co_mod_a2c else ""
        # Kontynuuj dodawanie pozostałych zmiennych

        output += "\nPOMIARY LEWEJ I PRAWEJ KOMORY\n"
        output += "PROJEKCJE M-Mode\n"
        output += "RVIDd światło prawej komory w rozkurczu = {}\n".format(rvidd) if rvidd else ""
        output += "RVIDs światło prawej komory w skurczu = {}\n".format(rvids) if rvids else ""
        output += "IVSd grubość przegrody międzykomorowej w rozkurczu = {}\n".format(ivsd) if ivsd else ""
        output += "LVIDd światło lewej komory w rozkurczu = {}\n".format(lvidd) if lvidd else ""
        output += "LVPWd grubość wolnej ściany lewej komory w rozkurczu = {}\n".format(lvpwd) if lvpwd else ""
        output += "IVSs grubość przegrody międzykomorowej w skurczu = {}\n".format(ivss) if ivss else ""
        output += "LVIDs światło lewej komory w skurczu = {}\n".format(lvids) if lvids else ""
        output += "LVPWs grubość wolnej ściany lewej komory w skurczu = {}\n".format(lvpws) if lvpws else ""
        output += "%FS = {}\n".format(fs) if fs else ""
        output += "LVIDDN wymiar telediastolowy wtórny = {}\n".format(lviddn) if lviddn else ""
        output += "LVIDSN wymiar skurczowy wtórny = {}\n".format(lvidsn) if lvidsn else ""
        output += "\nDoppler\n"
        output += "Echokardiograficzne parametry przepływu\n"
        output += "MV E Vel maksymalna prędkość wczesnego napływu mitralnego = {}\n".format(
            mv_e_vel) if mv_e_vel else ""
        output += "MV A Vel maksymalna prędkość późnego napływu mitralnego = {}\n".format(mv_a_vel) if mv_a_vel else ""
        output += "MV E/A Ratio = {}\n".format(mv_ea_ratio) if mv_ea_ratio else ""
        output += "LVOT Vmax prędkość przepływu przez aortę = {}\n".format(lvot_vmax) if lvot_vmax else ""
        output += "LVOT maxPG gradient ciśnienia = {}\n".format(lvot_maxpg) if lvot_maxpg else ""
        output += "RVOT Vmax prędkość przepływu przez pień płucny = {}\n".format(rvot_vmax) if rvot_vmax else ""
        output += "RVOT maxPG gradient ciśnienia = {}\n".format(rvot_maxpg) if rvot_maxpg else ""
        output += "\nPomiar rytmu serca\n"
        output += "Czas cyklu = {}\n".format(time) if time else ""
        output += "Częstość rytmu = {}\n".format(hr) if hr else ""

        output += """Wnioski: W badaniu uwidoczniono pogrubienie płatków
        zastawki dwudzielnej z niewielką niedomykalnością. Zastawka trójdzielna
        także z niewielką niedomykalnością. Wielkość jam serca prawidłowa,
        stosowna do masy ciała.
        Kurczliwość mięśnia sercowego
        w normie. Grubość przegrody międzykomorowej i wolnej ściany lewej
        komory prawidłowa, stosowna do masy ciała. Przepływ
        przez aortę i pień płucny prawidłowy, prawidłowej prędkości, laminarny
        w badaniu doplerowskim. Brak płynu w worku
        osierdziowym.

        DIAGNOZA: DVD choroba zwyrodnieniowa zastawki dwudzielnej i
        trójdzielnej ACVIM B1 bez wskazań do leczenia

        Wskazana kontrola kardiologiczna za 12 miesięcy.

        Proszę liczyć oddechy w spoczynku, np podczas snu, norma poniżej
        30/min, w wypadku wzrostu liczby oddechów wskazana kontrola
        kardiologiczna wcześniej.

        Bez kardiologicznych przeciwwskazań do znieczulenia."""

        # Przygotowanie nazwy pliku opisu
        opis_file_name = ''

        if patient_id:
            opis_file_name = 'opis_{}.txt'.format(re.sub(r"\W+", "", patient_id.strip()))
        elif name:
            opis_file_name = 'opis_{}.txt'.format(re.sub(r"\W+", "", name.strip()))
        else:
            base_name = os.path.splitext(file_name)[0]
            opis_file_name = 'opis_{}.txt'.format(re.sub(r"\W+", "", base_name))

        opis_file_path = os.path.join(opisy_folder_path, opis_file_name)

        # Sprawdzenie, czy plik opisu już istnieje
        if os.path.exists(opis_file_path):
            print(f"Plik opisu już istnieje dla pliku {file_name}")
        else:
            # Zapisanie opisu do pliku
            with open(opis_file_path, 'w', encoding='utf-8') as opis_file:
                opis_file.write(output)

    print(f"Przetworzono plik: {file_name}. Utworzono opis: {opis_file_name}")

# Tworzenie wiadomości e-mail
#msg = MIMEText(output)
#msg['Subject'] = 'Raport wyników badania'
#msg['From'] = 'michal.swierk.sw@gmail.com'
#msg['To'] = 'michal.swierk.sw@gmail.com'

# Konfiguracja serwera SMTP
#smtp_server = 'smtp.gmail.com'
#smtp_port =
#smtp_username = ''
#smtp_password = ''

# Wysłanie wiadomości e-mail jako kopia robocza
#with smtplib.SMTP(smtp_server, smtp_port) as server:
   # server.starttls()
    #server.login(smtp_username, smtp_password)
    #server.send_message(msg)



#print("Zapisano kopię roboczą wiadomości do pliku wiadomosc.txt.")

