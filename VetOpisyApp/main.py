import tkinter as tk
from tkinter import filedialog, messagebox
import os
import shutil
import subprocess

# Funkcje

def generate_description():
    script_path = "D:/Skrypt VIVID IQ/main.py"  # ścieżka do skryptu
    subprocess.run(["python", script_path])

def open_file_in_notepad(file_path):
    subprocess.run(["notepad.exe", file_path])

def import_file():
    file_path = filedialog.askopenfilename(filetypes=[("Text files", "*.txt")])
    if file_path:
        target_folder = "D:/Skrypt VIVID IQ/pliki źródłowe"  #ścieżka do folderu źródłowego
        shutil.copy(file_path, target_folder)
        messagebox.showinfo("Import Pliku", f"Plik {os.path.basename(file_path)} zaimportowany do pliki źródłowe.")

def open_files_folder():
    os.system("explorer.exe D:/Skrypt VIVID IQ/pliki źródłowe")  # Otwiera eksplorator plików w folderze źródłowym

def open_descriptions_folder():
    os.system("explorer.exe D:/Skrypt VIVID IQ/opisy")  # Otwiera eksplorator plików w folderze opisów

def open_descriptions():
    files = os.listdir("D:/Skrypt VIVID IQ/opisy")  #ścieżka do folderu opisów
    description_files = [file for file in files if file.endswith(".txt")]
    if description_files:
        description_window = tk.Toplevel(root)
        description_window.title("Lista Opisów")

        listbox = tk.Listbox(description_window)
        listbox.pack()

        for file in description_files:
            listbox.insert(tk.END, file)

        open_button = tk.Button(description_window, text="Otwórz", command=lambda: open_selected_description(listbox))
        open_button.pack()

    else:
        messagebox.showinfo("Brak Opisów", "Brak dostępnych opisów.")

def open_selected_description(listbox):
    selected_index = listbox.curselection()
    if selected_index:
        selected_file = listbox.get(selected_index[0])
        file_path = os.path.join("D:/Skrypt VIVID IQ/opisy", selected_file)  #ścieżka do folderu opisów
        open_file_in_notepad(file_path)
    else:
        messagebox.showwarning("Brak Wyboru", "Nie wybrano żadnego opisu.")
def open_files_list():
    files = os.listdir("D:/Skrypt VIVID IQ/pliki źródłowe")  # ścieżka do folderu źródłowego
    files_window = tk.Toplevel(root)
    files_window.title("Lista Plików Źródłowych")

    listbox = tk.Listbox(files_window)
    listbox.pack()

    for file in files:
        listbox.insert(tk.END, file)

# GUI

root = tk.Tk()
root.title("Aplikacja do Opisów")


root.geometry("500x400")
root.configure(padx=20, pady=20)


header_label = tk.Label(root, text="iVet App", font=("Helvetica", 16, "bold"))
header_label.pack(pady=10)

# Przycisk Generuj Opis
generate_button = tk.Button(root, text="Generuj Opis", command=generate_description)
generate_button.pack(pady=10)

# Frame dla sekcji plików źródłowych
files_frame = tk.Frame(root)
files_frame.pack(pady=20)

# Przycisk Lista Plików Źródłowych
files_button = tk.Button(files_frame, text="Lista Plików Źródłowych", command=open_files_list)
files_button.pack(side=tk.LEFT, padx=5)

# Przycisk Importuj Plik Źródłowy
import_button = tk.Button(files_frame, text="Importuj Plik Źródłowy", command=import_file)
import_button.pack(side=tk.LEFT, padx=5)

# Frame dla sekcji opisów
description_frame = tk.Frame(root)
description_frame.pack(pady=20)

# Przycisk Lista Opisów
description_button = tk.Button(description_frame, text="Lista Opisów", command=open_descriptions)
description_button.pack()

root.mainloop()