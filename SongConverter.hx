#if !interp
package art;

// needs this thing to be run by interp, just for me lol!
#end
import haxe.Json;
import haxe.Log;
import sys.FileSystem;
import sys.io.File;

class SongConverter
{
	// TODO
	// Update engine shit, to accomodate single file
	static function main()
	{
		Sys.stdout().writeString('Please type directory you want to convert: ');
		Sys.stdout().flush();
		final input = Sys.stdin().readLine();
		trace('Hello ${input}!');

		for (fileThing in FileSystem.readDirectory('${input}/.'))
		{
			if (FileSystem.isDirectory(fileThing) && fileThing.toLowerCase() != 'smash')
			{
				trace('Formatting $fileThing');
				formatSongs(fileThing);
			}
		}
	}

	public static function formatSongs(songName:String)
	{
		var existsArray:Array<Bool> = [];
		var songFiles:Array<String> = [
			'$songName/$songName-easy.json',
			'$songName/$songName.json',
			'$songName/$songName-hard.json'
		];

		existsArray.push(FileSystem.exists(songFiles[0]));
		existsArray.push(FileSystem.exists(songFiles[1]));
		existsArray.push(FileSystem.exists(songFiles[2]));

		// ALWAYS ASSUMES THAT 'songName.json' EXISTS AT LEAST!!!
		if (!existsArray[0])
			songFiles[0] = songFiles[1];
		if (!existsArray[2])
			songFiles[2] = songFiles[1];

		var fileNormal:Dynamic = cast Json.parse(File.getContent(songFiles[0]));
		var fileHard:Dynamic = cast Json.parse(File.getContent(songFiles[1]));
		var fileEasy:Dynamic = cast Json.parse(File.getContent(songFiles[2]));

		var daOgNotes:Dynamic = fileNormal.song.notes;
		var daOgSpeed:Float = fileNormal.song.speed;

		fileNormal.song.notes = [];
		fileNormal.song.speed = [];

		// fileEasy.song.notes = noteCleaner(fileEasy.song.notes);
		// daOgNotes = noteCleaner(daOgNotes);
		// fileHard.song.notes = noteCleaner(fileHard.song.notes);

		fileNormal.song.notes.push(fileEasy.song.notes);
		fileNormal.song.notes.push(daOgNotes);
		fileNormal.song.notes.push(fileHard.song.notes);

		fileNormal.song.speed.push(fileEasy.song.speed);
		fileNormal.song.speed.push(daOgSpeed);
		fileNormal.song.speed.push(fileHard.song.speed);
		fileNormal.song.hasDialogueFile = false;
		fileNormal.song.stageDefault = getStage(songName);

		// trace(fileNormal.song.speed);

		var daJson = Json.stringify(fileNormal);
		File.saveContent('$songName/$songName-new.json', daJson);
	}

	static function noteCleaner(notes:Array<Dynamic>):Array<Dynamic>
	{
		var swagArray:Array<Dynamic> = [];
		for (i in notes)
		{
			if (i.sectionNotes.length > 0)
				swagArray.push(i);
		}

		return swagArray;
	}

	/**
	 * Quicky lil function just for me formatting the old songs hehehe	
	 */
	static function getStage(songName:String):String
	{
		switch (songName)
		{
			case 'spookeez' | 'monster' | 'south':
				return "spooky";
			case 'pico' | 'blammed' | 'philly':
				return 'philly';
			case "milf" | 'satin-panties' | 'high':
				return 'limo';
			case "cocoa" | 'eggnog':
				return 'mall';
			case 'winter-horrorland':
				return 'mallEvil';
			case 'senpai' | 'roses':
				return 'school';
			case 'thorns':
				return 'schoolEvil';
			case 'guns' | 'stress' | 'ugh':
				return 'tank';
			default:
				return 'stage';
		}
	}
}
