# Получаем список иконок
$allSvgFiles = Get-ChildItem -Path ".\assets" -Filter "*.svg"
$icons = $allSvgFiles | 
    Where-Object { $_.Name -notmatch "-light\.svg$" -and $_.Name -notmatch "-dark\.svg$" } |
    Select-Object -ExpandProperty Name |
    Sort-Object

$iconsCount = $icons.Count
Write-Host "Found $iconsCount valid icons"

# Вычисляем количество колонок
$columns = [math]::Ceiling($iconsCount / 100)
Write-Host "Creating table with $columns columns"

# Создаем начальный контент README
$initialContent = @"
<p align="center"><img align="center" width="280" src="./.github/text-logo.svg#gh-dark-mode-only"/></p>
<p align="center"><img align="center" width="280" src="./.github/text-logo-light.svg#gh-light-mode-only"/></p>
<h3 align="center">Showcase your skills on your GitHub or resumé with ease!</h3>
<hr>

# Docs

- [Docs](#docs)
- [Example](#example)
- [Specifying Icons](#specifying-icons)
- [Themed Icons](#themed-icons)
- [Icons Per Line](#icons-per-line)
- [Get Icons Names](#get-icons-names)
- [Centering Icons](#centering-icons)
- [Icons List](#icons-list)
- [💖 Support the Project](#-support-the-project)

# Example

<p align="center"><img align="center" src="./.github/example-dark.png#gh-dark-mode-only"/></p>
<p align="center"><img align="center" src="./.github/example-light.png#gh-light-mode-only"/></p>

# Specifying Icons

Copy and paste the code block below into your readme to add the skills icon element!

Change the `?i=js,html,css` to a list of your skills separated by ","s! You can find a full list of icons [here](#icons-list).

\`\`\`md
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=js,html,css,wasm)
\`\`\`

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=js,html,css,wasm)

# Themed Icons

Some icons have a dark and light themed background. You can specify which theme you want as a url parameter.

This is optional. The default theme is dark.

Change the `&theme=light` to either `dark` or `light`. The theme is the background color, so light theme has a white icon background, and dark has a black-ish.

**Light Theme Example:**

\`\`\`md
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=java,kotlin,nodejs,figma&theme=light)
\`\`\`

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=java,kotlin,nodejs&theme=light)

# Icons Per Line

You can specify how many icons you would like per line! It's an optional argument, and the default is 15.

Change the `&perline=3` to any number between 1 and 50.

\`\`\`md
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=aws,gcp,azure,react,vue,flutter&perline=3)
\`\`\`

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=aws,gcp,azure,react,vue,flutter&perline=3)

# Get Icons Names

You can get the possiblity to add the name of the icons you put to help others that doesnt know what they are by using `&titles`.

The value of `titles` is a boolean, so it should be `true` or `false`, default is `false`

\`\`\`md
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=rust,surrealdb,actix,yew&titles=true)
\`\`\`

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=rust,surrealdb,actix,yew&titles=true)

# Centering Icons

Want to center the icons in your readme? The SVGs are automatically resized, so you can do it the same way you'd normally center an image.

\`\`\`html
<p align="center">
  <a href="https://go-skill-icons.vercel.app/">
    <img
      src="https://go-skill-icons.vercel.app/api/icons?i=git,kubernetes,docker,c,vim"
    />
  </a>
</p>
\`\`\`

<p align="center">
  <a href="https://go-skill-icons.vercel.app/">
    <img src="https://go-skill-icons.vercel.app/api/icons?i=git,kubernetes,docker,c,vim" />
  </a>
</p>

"@

# Создаем заголовок таблицы
$headerRow = ""
$separatorRow = ""
for ($i = 0; $i -lt $columns; $i++) {
    $headerRow += "| Icon ID | Icon "
    $separatorRow += "| :-----------------: | :--------------: "
}
$headerRow += "|"
$separatorRow += "|"

# Создаем содержимое таблицы
$tableContent = @"
# Icons List

$headerRow
$separatorRow

"@

# Заполняем таблицу построчно
for ($row = 0; $row -lt 100; $row++) {
    $rowContent = ""
    $hasContent = $false

    for ($col = 0; $col -lt $columns; $col++) {
        $index = ($col * 100) + $row
        if ($index -lt $iconsCount) {
            $icon = $icons[$index]
            $iconId = $icon -replace '\.svg$' -replace '-auto'
            $rowContent += "| ``$iconId`` | <img src=`"./assets/$icon`" width=`"48`"> "
            $hasContent = $true
        } else {
            if ($col -lt ($columns - 1)) {
                $rowContent += "| | "
            }
        }
    }

    if ($hasContent) {
        $rowContent += "|"
        $tableContent += "$rowContent`n"
    }
}

# Добавляем секцию поддержки
$tableContent += @"

# 💖 Support the Project
Thank you so much already for using my projects!
To support the project directly, feel free to open issues for icon suggestions, or contribute with a pull request!
"@

# Объединяем весь контент
$finalContent = $initialContent + "`n`n" + $tableContent

# Сохраняем результат
$finalContent | Set-Content -Path "README.md" -Encoding UTF8

Write-Host "README.md has been updated successfully!"