-- ============================================================================
-- ПОЛНЫЙ ГАЙД ПО АННОТАЦИЯМ ТИПОВ В LUA
-- ============================================================================

-- ============================================================================
-- 1. БАЗОВЫЕ ТИПЫ
-- ============================================================================

---@param name string          -- строка
---@param age number           -- число
---@param isActive boolean     -- логический тип
---@param data table           -- любая таблица
---@param callback function    -- функция
---@param value nil            -- пустое значение
---@param anything any         -- любой тип
function basicTypes(name, age, isActive, data, callback, value, anything)
    -- примеры использования
end

-- ============================================================================
-- 2. ТАБЛИЦЫ (МАССИВЫ И СЛОВАРИ)
-- ============================================================================

-- Простые массивы
---@param items string[]       -- массив строк
---@param numbers number[]     -- массив чисел
---@param flags boolean[]      -- массив булевых значений
function simpleArrays(items, numbers, flags)
    -- items = {"hello", "world"}
    -- numbers = {1, 2, 3}
    -- flags = {true, false, true}
end

-- Словари (ключ-значение)
---@param config table<string, string>    -- ключи строки, значения строки
---@param settings table<string, number>  -- ключи строки, значения числа
---@param cache table<number, boolean>    -- ключи числа, значения булевы
---@param mixed table<string, any>        -- ключи строки, значения любые
function dictionaries(config, settings, cache, mixed)
    -- config = {host = "localhost", port = "8080"}
    -- settings = {volume = 0.5, brightness = 100}
    -- cache = {[1] = true, [2] = false}
    -- mixed = {name = "John", age = 25, active = true}
end

-- Многомерные массивы
---@param matrix number[][]               -- двумерный массив чисел
---@param grid string[][]                 -- двумерный массив строк
---@param complex table<string, number[]> -- словарь где значения - массивы чисел
function multidimensionalArrays(matrix, grid, complex)
    -- matrix = {{1, 2}, {3, 4}}
    -- grid = {{"a", "b"}, {"c", "d"}}
    -- complex = {scores = {10, 20, 30}, levels = {1, 2, 3}}
end

-- Смешанные структуры
---@param data table<string, string | number>     -- значения могут быть строкой или числом
---@param items (string | number)[]               -- массив строк или чисел
---@param nested table<string, table<string, any>> -- вложенные словари
function mixedStructures(data, items, nested)
    -- data = {name = "John", age = 25}
    -- items = {"hello", 42, "world", 13}
    -- nested = {user = {name = "John", settings = {theme = "dark"}}}
end

-- ============================================================================
-- 3. UNION ТИПЫ (НЕСКОЛЬКО ВОЗМОЖНЫХ ТИПОВ)
-- ============================================================================

---@param value string | number           -- строка ИЛИ число
---@param result boolean | nil            -- булево ИЛИ nil
---@param data table | string | nil       -- таблица ИЛИ строка ИЛИ nil
---@param callback function | nil         -- функция ИЛИ nil (опциональный)
function unionTypes(value, result, data, callback)
    -- value может быть "hello" или 42
    -- result может быть true, false или nil
    -- data может быть {}, "text" или nil
    -- callback может быть function() end или nil
end

-- ============================================================================
-- 4. ЛИТЕРАЛЬНЫЕ ТИПЫ (КОНКРЕТНЫЕ ЗНАЧЕНИЯ)
-- ============================================================================

---@param action "play" | "pause" | "stop"        -- только эти строки
---@param level 1 | 2 | 3 | 4 | 5                -- только эти числа
---@param status "success" | "error" | "pending"  -- только эти статусы
function literalTypes(action, level, status)
    -- action может быть только "play", "pause" или "stop"
    -- level может быть только 1, 2, 3, 4 или 5
    -- status может быть только "success", "error" или "pending"
end

-- ============================================================================
-- 5. ФУНКЦИИ
-- ============================================================================

-- Простая функция
---@param callback function
function simpleFunction(callback)
    callback()
end

-- Функция с типизацией параметров и возврата
---@param callback fun(name: string, age: number): boolean
function typedFunction(callback)
    local result = callback("John", 25)
    return result
end

-- Функция с несколькими параметрами
---@param handler fun(event: string, data: table, callback: function): void
function complexFunction(handler)
    handler("click", {x = 10, y = 20}, function() end)
end

-- Функция с опциональными параметрами
---@param processor fun(input: string, options?: table): string | nil
function optionalParamsFunction(processor)
    local result1 = processor("hello")
    local result2 = processor("world", {uppercase = true})
end

-- ============================================================================
-- 6. ОПЦИОНАЛЬНЫЕ ПАРАМЕТРЫ
-- ============================================================================

---@param name string          -- обязательный
---@param age number?          -- опциональный (может быть nil)
---@param callback function?   -- опциональный
---@param options table?       -- опциональный
function optionalParameters(name, age, callback, options)
    -- name всегда должен быть передан
    -- age, callback, options могут быть nil
    if age then
        print("Age: " .. age)
    end
    if callback then
        callback()
    end
end

-- ============================================================================
-- 7. КЛАССЫ И ОБЪЕКТЫ
-- ============================================================================

-- Определение класса
---@class Player
---@field name string
---@field level number
---@field inventory table<string, number>
---@field isAlive boolean
---@field position {x: number, y: number, z: number}
local Player = {}

-- Использование класса
---@param player Player
---@return Player
function processPlayer(player)
    print(player.name)
    print(player.level)
    return player
end

-- Создание экземпляра (для примера)
---@type Player
local myPlayer = {
    name = "Hero",
    level = 10,
    inventory = {sword = 1, potion = 5},
    isAlive = true,
    position = {x = 0, y = 0, z = 0}
}

-- ============================================================================
-- 8. ПЕРЕЧИСЛЕНИЯ (ENUMS)
-- ============================================================================

-- Определение enum
---@enum ActionType
local ActionType = {
    PLAY = "play",
    PAUSE = "pause",
    STOP = "stop"
}

---@enum LogLevel
local LogLevel = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4
}

-- Использование
---@param action ActionType
---@param level LogLevel
function useEnums(action, level)
    if action == ActionType.PLAY then
        print("Playing...")
    end
    if level >= LogLevel.WARN then
        print("Warning or error!")
    end
end

-- ============================================================================
-- 9. АЛИАСЫ ТИПОВ
-- ============================================================================

-- Создание алиасов
---@alias EntityID string | number
---@alias Position {x: number, y: number, z: number}
---@alias AnimationData table<string, {id: number, duration: number}>
---@alias EventHandler fun(eventType: string, data: any): void
---@alias ConfigValue string | number | boolean

-- Использование алиасов
---@param entityId EntityID
---@param pos Position
---@param animations AnimationData
---@param handler EventHandler
---@param config table<string, ConfigValue>
function useAliases(entityId, pos, animations, handler, config)
    -- entityId может быть "player1" или 12345
    -- pos = {x = 10, y = 20, z = 30}
    -- animations = {walk = {id = 1, duration = 1.5}}
    -- handler = function(eventType, data) end
    -- config = {name = "Game", version = 1.0, debug = true}
end

-- ============================================================================
-- 10. ДЖЕНЕРИКИ (GENERICS)
-- ============================================================================

---@generic T
---@param items T[]
---@return T | nil
function getFirst(items)
    return items[1]
end

---@generic K, V
---@param dict table<K, V>
---@param key K
---@return V | nil
function getValue(dict, key)
    return dict[key]
end

-- Использование дженериков
local stringArray = {"hello", "world"}
local firstString = getFirst(stringArray) -- тип: string | nil

local numberDict = {a = 1, b = 2}
local value = getValue(numberDict, "a") -- тип: number | nil

-- ============================================================================
-- 11. СТРУКТУРЫ ОБЪЕКТОВ
-- ============================================================================

-- Inline структура
---@param config {host: string, port: number, ssl: boolean}
function connectToServer(config)
    -- config = {host = "localhost", port = 8080, ssl = true}
end

-- С опциональными полями
---@param options {name: string, age?: number, active?: boolean}
function createUser(options)
    -- options = {name = "John"}
    -- или options = {name = "John", age = 25, active = true}
end

-- Вложенные структуры
---@param user {
---   name: string,
---   profile: {
---     email: string,
---     settings: table<string, any>
---   },
---   permissions: string[]
--- }
function processUser(user)
    print(user.name)
    print(user.profile.email)
    for _, permission in ipairs(user.permissions) do
        print(permission)
    end
end

-- ============================================================================
-- 12. ВОЗВРАЩАЕМЫЕ ЗНАЧЕНИЯ
-- ============================================================================

---@return string              -- возвращает строку
function getString()
    return "hello"
end

---@return number | nil        -- возвращает число или nil
function getNumber()
    return math.random() > 0.5 and 42 or nil
end

---@return boolean, string     -- возвращает два значения
function getStatusAndMessage()
    return true, "Success"
end

---@return ...                 -- возвращает переменное количество значений
function getMultipleValues()
    return 1, 2, 3, "hello", true
end

-- ============================================================================
-- 13. АННОТАЦИИ ПЕРЕМЕННЫХ
-- ============================================================================

---@type string
local playerName = "Hero"

---@type number[]
local scores = {10, 20, 30}

---@type table<string, function>
local handlers = {
    click = function() print("clicked") end,
    hover = function() print("hovered") end
}

---@type Player
local currentPlayer = {
    name = "Test",
    level = 1,
    inventory = {},
    isAlive = true,
    position = {x = 0, y = 0, z = 0}
}

-- ============================================================================
-- 14. ПОЛЯ КЛАССА
-- ============================================================================

---@class GameObject
---@field public name string           -- публичное поле
---@field private _id number           -- приватное поле
---@field protected _data table        -- защищенное поле
---@field static COUNT number          -- статическое поле
---@field readonly uuid string         -- только для чтения
local GameObject = {}

-- ============================================================================
-- 15. ПРИМЕРЫ ИЗ РЕАЛЬНОГО КОДА
-- ============================================================================

-- Работа с анимациями
---@class AnimationInfo
---@field id number
---@field name string
---@field duration number
---@field loop boolean
---@field events table<string, fun(): void>

---@param animations table<string, AnimationInfo>
---@param selectedName string
---@param action "play" | "pause" | "stop"
---@return boolean success, string? error
function playAnimation(animations, selectedName, action)
    local anim = animations[selectedName]
    if not anim then
        return false, "Animation not found"
    end
    
    if action == "play" then
        -- play logic
        return true
    elseif action == "pause" then
        -- pause logic
        return true
    elseif action == "stop" then
        -- stop logic
        return true
    end
    
    return false, "Unknown action"
end

-- Конфигурация игры
---@class GameConfig
---@field graphics {resolution: string, fullscreen: boolean, vsync: boolean}
---@field audio {masterVolume: number, musicVolume: number, sfxVolume: number, muted: boolean}
---@field controls table<string, string>
---@field gameplay {difficulty: "easy" | "normal" | "hard", autoSave: boolean}

---@param config GameConfig
function applyGameConfig(config)
    -- применяем настройки графики
    setResolution(config.graphics.resolution)
    setFullscreen(config.graphics.fullscreen)
    
    -- применяем настройки звука
    setMasterVolume(config.audio.masterVolume)
    
    -- применяем управление
    for action, key in pairs(config.controls) do
        bindKey(key, action)
    end
end

-- Система событий
---@alias EventCallback fun(data: any): void
---@alias EventMap table<string, EventCallback[]>

---@param eventMap EventMap
---@param eventName string
---@param callback EventCallback
function addEventListener(eventMap, eventName, callback)
    if not eventMap[eventName] then
        eventMap[eventName] = {}
    end
    table.insert(eventMap[eventName], callback)
end

---@param eventMap EventMap
---@param eventName string
---@param data any
function triggerEvent(eventMap, eventName, data)
    local callbacks = eventMap[eventName]
    if callbacks then
        for _, callback in ipairs(callbacks) do
            callback(data)
        end
    end
end

-- ============================================================================
-- 16. ПЕРЕГРУЗКА ФУНКЦИЙ
-- ============================================================================

---@overload fun(name: string): Player
---@overload fun(id: number): Player
---@overload fun(criteria: {name?: string, level?: number}): Player[]
---@param identifier string | number | table
---@return Player | Player[] | nil
function findPlayer(identifier)
    if type(identifier) == "string" then
        -- поиск по имени
        return nil -- Player or nil
    elseif type(identifier) == "number" then
        -- поиск по ID
        return nil -- Player or nil
    elseif type(identifier) == "table" then
        -- поиск по критериям
        return {} -- Player[]
    end
    return nil
end

-- ============================================================================
-- 17. ПОЛЕЗНЫЕ ПАТТЕРНЫ
-- ============================================================================

-- Опциональные поля в конфигурации
---@param options {
---   timeout?: number,
---   retries?: number,
---   debug?: boolean,
---   headers?: table<string, string>,
---   onSuccess?: fun(data: any): void,
---   onError?: fun(error: string): void
--- }
function makeRequest(options)
    local timeout = options.timeout or 30
    local retries = options.retries or 3
    local debug = options.debug or false
    
    -- логика запроса
    if options.onSuccess then
        options.onSuccess({result = "ok"})
    end
end

-- Функции высшего порядка
---@generic T
---@param array T[]
---@param predicate fun(item: T, index: number): boolean
---@return T[]
function filter(array, predicate)
    local result = {}
    for i, item in ipairs(array) do
        if predicate(item, i) then
            table.insert(result, item)
        end
    end
    return result
end

---@generic T, R
---@param array T[]
---@param mapper fun(item: T, index: number): R
---@return R[]
function map(array, mapper)
    local result = {}
    for i, item in ipairs(array) do
        result[i] = mapper(item, i)
    end
    return result
end

-- Использование
local numbers = {1, 2, 3, 4, 5}
local evenNumbers = filter(numbers, function(n) return n % 2 == 0 end)
local doubled = map(numbers, function(n) return n * 2 end)

-- ============================================================================
-- 18. СЛОЖНЫЕ ПРИМЕРЫ
-- ============================================================================

-- Система плагинов
---@class Plugin
---@field name string
---@field version string
---@field dependencies string[]
---@field init fun(config: table): boolean
---@field destroy fun(): void
---@field api table<string, function>

---@class PluginManager
---@field plugins table<string, Plugin>
---@field loadOrder string[]
local PluginManager = {}

---@param self PluginManager
---@param plugin Plugin
---@return boolean success, string? error
function PluginManager:registerPlugin(plugin)
    if self.plugins[plugin.name] then
        return false, "Plugin already exists"
    end
    
    self.plugins[plugin.name] = plugin
    table.insert(self.loadOrder, plugin.name)
    return true
end

-- Система анимаций (как в вашем коде)
---@class AnimationSystem
---@field animations table<string, {id: number, duration: number}>
---@field history string[]
---@field currentAnimation string?
local AnimationSystem = {}

---@param self AnimationSystem
---@param entity any
---@param animationName string
---@param action "play" | "pause" | "stop"
---@param random boolean?
---@return boolean success
function AnimationSystem:playAnimation(entity, animationName, action, random)
    -- добавляем в историю если анимации там нет
    local found = false
    for _, name in ipairs(self.history) do
        if name == animationName then
            found = true
            break
        end
    end
    
    if not found then
        table.insert(self.history, animationName)
    end
    
    -- выполняем действие
    if action == "play" then
        self.currentAnimation = animationName
        return true
    elseif action == "pause" or action == "stop" then
        if action == "stop" then
            self.currentAnimation = nil
        end
        return true
    end
    
    return false
end