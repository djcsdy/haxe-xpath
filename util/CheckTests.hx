import neko.FileSystem;
import neko.Lib;
import neko.Sys;
import neko.io.File;
import neko.io.FileOutput;


class CheckTests {
	
	private static var sourceFiles:Array<String>;
	
	private static var unitTestFiles:Hash<String>;
	
	private static var unitTestSyms:Array<String>;
	
	
	public static function main () :Void {
		sourceFiles = new Array<String>();
		unitTestFiles = new Hash<String>();
		unitTestSyms = new Array<String>();
		
		if (FileSystem.isDirectory("src")) {
			scanDirectory("src", "src", "");
			
			for (sourceFile in sourceFiles) {
				if (unitTestFiles.exists(sourceFile)) {
					var unitTestFile:String = unitTestFiles.get(sourceFile);
					
					var sourceStat:FileStat = FileSystem.stat(sourceFile);
					var sourceModified:Date = sourceStat.mtime;
					var unitTestStat:FileStat = FileSystem.stat(unitTestFile);
					var unitTestModified:Date = unitTestStat.mtime;
					
					if (sourceModified.getTime() > unitTestModified.getTime()) {
						Lib.println(
							"CheckTests: Warning: test '" + unitTestFile + "' is older than " +
							"corresponding source file '" + sourceFile + "'."
						);
					}
					
					unitTestFiles.remove(sourceFile);
				} else {
					Lib.println("CheckTests: Warning: '" + sourceFile + "' has no unit test");
				}
			}
			
			for (sourceFile in unitTestFiles.keys()) {
				Lib.println(
					"CheckTests: Warning: '" + unitTestFiles.get(sourceFile) + "' has no corresponding " +
					"source file '" + sourceFile + "'"
				);
			}
			
			if (!FileSystem.exists("build/test") || !FileSystem.isDirectory("build/test")) {
				Lib.print("CheckTests: build directory 'build/test/' not found");
				Sys.exit(1);
			}
			
			Sys.setCwd("build/test");
			var outFile:FileOutput = File.write("TestMain.hx", false);
			outFile.write(
				"import haxe.unit.TestRunner;\n" +
				"#if neko\n" +
				"import neko.Sys;\n" +
				"#end\n" +
				"\n" +
				"\n" +
				"class TestMain {\n" +
				"\n" +
				"\tpublic static function main () :Void {\n" +
				"\t\tvar r:TestRunner = new TestRunner();\n"
			);
			for (sym in unitTestSyms) {
				outFile.write("\t\tr.add(new " + sym + "());\n");
			}
			outFile.write(
				"\n" +
				"\t\t#if neko\n" +
				"\t\tif (r.run()) Sys.exit(0);\n" +
				"\t\telse Sys.exit(1);\n" +
				"\t\t#else true\n" +
				"\t\tr.run();\n" +
				"\t\t#end\n" +
				"\t}\n" +
				"\n" +
				"}\n"
			);
			outFile.close();
			
			Sys.exit(0);
		} else {
			Lib.print("CheckTests: source directory 'src/' not found");
			Sys.exit(1);
		}
	}
	
	private static function scanDirectory (dirName:String, fullDirName:String, sym:String) :Void {
		var parentDir:String = Sys.getCwd();
		Sys.setCwd(dirName);
		
		for (fileName in FileSystem.readDirectory(".")) {
			if (FileSystem.isDirectory(fileName)) {
				if (fileName == "unit") {
					scanUnitDirectory(fileName, fullDirName+"/unit", fullDirName, sym+"unit.");
				} else {
					scanDirectory(fileName, fullDirName+"/"+fileName, sym+fileName+".");
				}
			} else if (fileName.substr(-3) == ".hx") {
				sourceFiles.push(fullDirName+"/"+fileName);
			}
		}
		
		Sys.setCwd(parentDir);
	}
	
	private static function scanUnitDirectory (
		dirName, fullDirName:String, fullSrcDirName:String, sym:String
	) :Void {
		var parentDir:String = Sys.getCwd();
		Sys.setCwd(dirName);
		
		for (fileName in FileSystem.readDirectory(".")) {
			if (FileSystem.isDirectory(fileName)) {
				scanUnitDirectory(
					fileName, fullDirName+"/"+fileName, fullSrcDirName+"/"+fileName, sym+fileName+"."
				);
			} else if (fileName.substr(-3) == ".hx" && fileName.substr(0, 4) == "Test") {
				var srcFileName:String = fileName.substr(4);
				var fullSrcFileName:String = fullSrcDirName+"/"+srcFileName;
				var fullFileName:String = fullDirName+"/"+fileName;
				unitTestFiles.set(fullSrcFileName, fullFileName);
				unitTestSyms.push(sym+fileName.substr(0, fileName.length-3));
			}
		}
		
		Sys.setCwd(parentDir);
	}
	
}