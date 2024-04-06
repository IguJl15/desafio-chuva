DateTime simplifiedDateTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

int colorCodeFromCss(String cssColor) =>
    (int.parse(cssColor.substring(1), radix: 16)) | (cssColor.length > 7 ? 0 : 0xFF000000);

const weekdays = [
  "Segunda-Feira",
  "Terça-Feira",
  "Quarta-Feira",
  "Quinta-Feira",
  "Sexta-Feira",
  "Sábado",
  "Domingo",
];
