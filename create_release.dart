import 'dart:io';

import 'package:github/github.dart';
import 'package:pub_semver/pub_semver.dart';
import "package:yaml/yaml.dart";

GitHub github = GitHub(auth: findAuthenticationFromEnvironment());
var env = Platform.environment;

String readVersionString() {
  final runNumber = env["GITHUB_RUN_NUMBER"];
  if (runNumber == null) {
    throw Error.safeToString("version code not found in environment variables");
  }
  final incrementVersion = env["INCREMENT_VERSION"] ?? "185";
  final versionCode = int.parse(runNumber) + int.parse(incrementVersion);
  final file = File("pubspec.yaml");
  final yaml = loadYaml(file.readAsStringSync());
  final version = Version.parse(yaml["version"] as String);
  final finalVersion = Version(
    version.major,
    version.minor,
    version.patch,
    build: versionCode.toString(),
  );
  // ignore: avoid_print
  print(finalVersion);
  return finalVersion.toString();
}

Future<List<File>> findFiles(String path) async {
  if (Directory(path).existsSync()) {
    // Path is a file
    final list = Directory(path).list();
    final files = list
        .where((a) => a.statSync().type == FileSystemEntityType.file)
        .map((a) => a as File)
        .toList();
    return files;
  } else {
    return [File(path)];
  }
}

void main(List<String> args) async {
  final versionString = readVersionString();
  final repo = env["GITHUB_REPOSITORY"];
  final releasePaths = env["RELEASE_PATHS"];
  if (repo == null || releasePaths == null) {
    throw Error.safeToString(
        "Repo or version code or release paths not found in environment variables");
  }
  final slug = RepositorySlug.full(repo);
  // ignore: avoid_print
  print("Fetching releases for $repo");
  final release = CreateRelease(versionString);
  release.isPrerelease = true;
  final createdRelease = await github.repositories.createRelease(
    slug,
    release,
    getIfExists: true,
  );
  // ignore: avoid_print
  print("Created release");
  final releaseFilePaths = releasePaths.split(",");
  final releaseAssets = <CreateReleaseAsset>[];
  for (var asset in releaseFilePaths) {
    final files = await findFiles(asset);
    for (var file in files) {
      if (!file.existsSync()) {
        throw Error.safeToString("File $asset not found");
      }
      releaseAssets.add(
        CreateReleaseAsset(
          name: file.path.split("/").last,
          contentType: "application/octet-stream",
          assetData: file.readAsBytesSync(),
        ),
      );
    }
  }
  // ignore: avoid_print
  print("Uploading release assets");
  await github.repositories.uploadReleaseAssets(createdRelease, releaseAssets);
  // ignore: avoid_print
  print("Uploaded release assets");
  exit(0);
}
