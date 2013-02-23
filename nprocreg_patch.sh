#!/bin/bash
patch -N -p1 -d ${REBAR_DEPS_DIR}/nprocreg/ < nprocreg.patch || true