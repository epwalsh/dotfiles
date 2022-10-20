#!/usr/bin/env python

import json
import sys

from tango.common.params import Params

if __name__ == "__main__":
    params = Params.from_file(sys.argv[1]).as_dict()
    print(json.dumps(params))
