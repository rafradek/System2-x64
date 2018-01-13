/**
 * -----------------------------------------------------
 * File        Request.cpp
 * Authors     David Ordnung
 * License     GPLv3
 * Web         http://dordnung.de
 * -----------------------------------------------------
 *
 * Copyright (C) 2013-2018 David Ordnung
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */

#include "Request.h"


Request::Request(std::string url, IPluginFunction *responseCallback) :
    url(url), port(-1), verifySSL(true), timeout(-1), data(0), responseCallback(responseCallback), progressCallback(NULL) {};

Request::Request(const Request &request) :
    url(request.url), port(request.port), outputFile(request.outputFile), verifySSL(request.verifySSL), timeout(request.timeout),
    data(request.data), responseCallback(request.responseCallback), progressCallback(request.progressCallback) {};

Request::~Request() {}