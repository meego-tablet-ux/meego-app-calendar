/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
Item {
    id: container

    property alias label: itemCrumb.label
    property variant model
    property alias crumb: itemCrumb
    Labs.Crumb {
        id: itemCrumb
    }
}
