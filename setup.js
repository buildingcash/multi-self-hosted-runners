#!/usr/bin/env -S yarn zx

'use strict';

import { $, argv, echo, fs, cd } from 'zx';
import dotenv from 'dotenv';

dotenv.config({ path: argv['env-file'] || ".env" });

const RUNNERS_NUMBER = parseInt(process.env.RUNNERS_NUMBER);
const RUNNER_HOME_PREFIX = `runner-home`;
const HOME_DIR = process.env.HOME_DIR;
const GITHUB_URL = process.env.GITHUB_URL;
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const RUNNERS_NAME_PREFIX = process.env.RUNNERS_NAME_PREFIX || "Self hosted";
const RUNNERS_GROUP = process.env.RUNNERS_GROUP || "Self hosted runners";
const RUNNERS_LABELS = process.env.RUNNERS_LABELS || "";
if (!HOME_DIR) {
    echo`No HOME_DIR defined`;
    process.exit(1);
}
if (!GITHUB_TOKEN || !GITHUB_URL) {
    echo`Github credentials are missing. Check GITHUB_HOME and GITHUB_TOKEN are specified.`;
}

if (!fs.existsSync(HOME_DIR)) {
    await $`mkdir -p ${HOME_DIR}`;
}

const RUNNERS_VERSION = process.env.RUNNERS_VERSION || "2.314.1";
const architecture = "osx-arm64"; // TODO: find out from system
const RUNNER_ARCHIVE = `actions-runner-${architecture}-${RUNNERS_VERSION}.tar.gz`;

cd(HOME_DIR);
await $`curl -o ${RUNNER_ARCHIVE} -L https://github.com/actions/runner/releases/download/v${RUNNERS_VERSION}/${RUNNER_ARCHIVE}`;

for (let i = 1; i <= RUNNERS_NUMBER; i++) {
    const name = `${RUNNERS_NAME_PREFIX} ${i}`;
    const dir = `${RUNNER_HOME_PREFIX}-${i}`;
    await $`mkdir -p ${dir}`;
    await $`tar xzf ./${RUNNER_ARCHIVE} --directory ${dir}`;

    await $`${dir}/config.sh --unattended --url ${GITHUB_URL} --token ${GITHUB_TOKEN} --name ${name} --runnergroup ${RUNNERS_GROUP} --labels ${RUNNERS_LABELS} --replace`;
    await $`cd ${dir}; ./svc.sh install`;
    await $`cd ${dir}; ./svc.sh start`;
}