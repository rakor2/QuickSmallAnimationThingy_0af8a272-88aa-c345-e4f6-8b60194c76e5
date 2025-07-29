import re
import sys

def safe_read_file(filename):
    """
    Безопасно читает файл построчно, избегая проблем с кодировкой
    """
    try:
        with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
            return f.readlines()
    except FileNotFoundError:
        print(f"Файл {filename} не найден!")
        return []
    except Exception as e:
        print(f"Ошибка чтения файла: {e}")
        return []

def extract_uuids_from_lines(lines):
    """
    Безопасно извлекает UUID из списка строк, разделяя на три группы
    """
    uuids_without_head_tail = []
    uuids_with_head = []
    uuids_with_tail = []
    
    # UUID паттерн
    uuid_pattern = r'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}'
    
    for line_num, line in enumerate(lines, 1):
        try:
            # Убираем все лишние символы и пробелы
            clean_line = line.strip()
            
            if not clean_line:
                continue
                
            # Ищем UUID в строке
            uuid_matches = re.findall(uuid_pattern, clean_line)
            
            if uuid_matches:
                # Берем последний найденный UUID (обычно он в конце)
                uuid = uuid_matches[-1]
                clean_lower = clean_line.lower()
                
                # Проверяем наличие "head" и "tail" в любом регистре
                has_head = 'head' in clean_lower
                has_tail = 'tail' in clean_lower
                
                if has_head:
                    uuids_with_head.append(uuid)
                elif has_tail:
                    uuids_with_tail.append(uuid)
                else:
                    uuids_without_head_tail.append(uuid)
                    
        except Exception as e:
            print(f"Ошибка в строке {line_num}: {e}")
            continue
    
    return uuids_without_head_tail, uuids_with_head, uuids_with_tail

def generate_safe_lua_tables(uuids_without_head_tail, uuids_with_head, uuids_with_tail):
    """
    Генерирует Lua таблицы безопасным способом для трех групп
    """
    lua_lines = []
    
    # Комментарий и таблица без Head и Tail
    lua_lines.append("-- UUID без Head и Tail")
    lua_lines.append("local uuidsWithoutHeadTail = {")
    
    for i, uuid in enumerate(uuids_without_head_tail):
        if i == len(uuids_without_head_tail) - 1:
            lua_lines.append(f'    "{uuid}"')
        else:
            lua_lines.append(f'    "{uuid}",')
    
    lua_lines.append("}")
    lua_lines.append("")
    
    # Комментарий и таблица с Head
    lua_lines.append("-- UUID с Head")
    lua_lines.append("local uuidsWithHead = {")
    
    for i, uuid in enumerate(uuids_with_head):
        if i == len(uuids_with_head) - 1:
            lua_lines.append(f'    "{uuid}"')
        else:
            lua_lines.append(f'    "{uuid}",')
    
    lua_lines.append("}")
    lua_lines.append("")
    
    # Комментарий и таблица с Tail
    lua_lines.append("-- UUID с Tail")
    lua_lines.append("local uuidsWithTail = {")
    
    for i, uuid in enumerate(uuids_with_tail):
        if i == len(uuids_with_tail) - 1:
            lua_lines.append(f'    "{uuid}"')
        else:
            lua_lines.append(f'    "{uuid}",')
    
    lua_lines.append("}")
    lua_lines.append("")
    
    # Возврат таблиц
    lua_lines.append("return {")
    lua_lines.append("    withoutHeadTail = uuidsWithoutHeadTail,")
    lua_lines.append("    withHead = uuidsWithHead,")
    lua_lines.append("    withTail = uuidsWithTail")
    lua_lines.append("}")
    
    return "\n".join(lua_lines)

def main():
    print("=== UUID Extractor ===")
    print("Поместите ваши данные в файл 'input_data.txt' в той же папке")
    print()
    
    # Читаем данные из файла
    input_filename = 'AnimationSets.txt'
    lines = safe_read_file(input_filename)
    
    if not lines:
        print("Создайте файл 'input_data.txt' и поместите туда ваш список!")
        print("Каждая строка должна содержать название и UUID")
        return
    
    print(f"Прочитано строк: {len(lines)}")
    
    # Извлекаем UUID
    uuids_without_head_tail, uuids_with_head, uuids_with_tail = extract_uuids_from_lines(lines)
    
    # Статистика
    print(f"Найдено UUID без 'Head' и 'Tail': {len(uuids_without_head_tail)}")
    print(f"Найдено UUID с 'Head': {len(uuids_with_head)}")
    print(f"Найдено UUID с 'Tail': {len(uuids_with_tail)}")
    print(f"Всего UUID: {len(uuids_without_head_tail) + len(uuids_with_head) + len(uuids_with_tail)}")
    
    if len(uuids_without_head_tail) == 0 and len(uuids_with_head) == 0 and len(uuids_with_tail) == 0:
        print("UUID не найдены! Проверьте формат данных.")
        return
    
    # Генерируем Lua код
    lua_output = generate_safe_lua_tables(uuids_without_head_tail, uuids_with_head, uuids_with_tail)
    
    # Сохраняем результат
    output_filename = 'separated_uuids.lua'
    try:
        with open(output_filename, 'w', encoding='utf-8') as f:
            f.write(lua_output)
        print(f"\nРезультат сохранен в '{output_filename}'")
    except Exception as e:
        print(f"Ошибка сохранения: {e}")
        print("\n=== LUA КОД ===")
        print(lua_output)

if __name__ == "__main__":
    main()