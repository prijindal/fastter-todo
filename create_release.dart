import 'dart:io';

import 'package:github/github.dart';

GitHub github = GitHub(auth: findAuthenticationFromEnvironment());

void main(List<String> args) async {
  var env = Platform.environment;
  final repo = env["GITHUB_REPOSITORY"];
  final versionCode = env["VERSION_CODE"] ?? env["GITHUB_RUN_NUMBER"];
  final releasePaths = env["RELEASE_PATHS"];
  if (repo == null || versionCode == null || releasePaths == null) {
    throw Error.safeToString(
        "Repo or version code or release paths not found in environment variables");
  }
  final slug = RepositorySlug.full(repo);
  // ignore: avoid_print
  print("Fetching releases for $repo");
  final release = CreateRelease(versionCode);
  final createdRelease =
      await github.repositories.createRelease(slug, release, getIfExists: true);
  // ignore: avoid_print
  print("Created release");
  final releaseFilePaths = releasePaths.split(",");
  final releaseAssets = <CreateReleaseAsset>[];
  for (var asset in releaseFilePaths) {
    final file = File(asset);
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
  // ignore: avoid_print
  print("Uploading release assets");
  await github.repositories.uploadReleaseAssets(createdRelease, releaseAssets);
  // ignore: avoid_print
  print("Uploaded release assets");
  exit(0);
}
