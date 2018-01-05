/**
 * -----------------------------------------------------
 * File        FTPRequest.h
 * Authors     David Ordnung
 * License     GPLv3
 * Web         http://dordnung.de
 * -----------------------------------------------------
 *
 * Copyright (C) 2013-2017 David Ordnung
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

#ifndef _SYSTEM2_FTP_REQUEST_H_
#define _SYSTEM2_FTP_REQUEST_H_

#include "Request.h"


class FTPRequest : public Request {
public:
    std::string file;
    std::string username;
    std::string password;
    bool appendToFile;
    bool createMissingDirs;

    FTPRequest(std::string url, IPluginFunction *responseCallback);

    void Download(Handle_t requestHandle, IdentityToken_t *owner);
    void Upload(Handle_t requestHandle, IdentityToken_t *owner);

private:
    void makeThread(bool download, Handle_t requestHandle, IdentityToken_t *owner);
};


#endif