import * as peg from "pegjs";
import * as fs from "fs-extra";

export function index() {
  let fileOffset = 0x0000;
  let parser = peg.generate(fs.readFileSync("./p.pegjs").toString());
  const main = fs.readFileSync("./1.cleo.scm").slice(fileOffset);

  try {
    let res = parser.parse(main.toString("binary"));
    console.log(res);
  } catch (e) {
    console.log(e);
    const offset = e.location.start.offset;
    console.error(
      `${e.message} @ ${(fileOffset + offset).toString(
        16
      )} == ${main.readInt16LE(offset).toString(16)}`
    );
  }
}
