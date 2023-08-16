/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
*/
/*------------------------------------------------------------------------
    File        : JsonConfigSeatBuilder
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk. Ltd.
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Entertainment.Builder.* from propath.
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.* from propath.
using Example.Entertainment.* from propath.

class Example.Entertainment.Builder.JsonConfigSeatBuilder
    inherits SeatBuilder:

    constructor public JsonConfigSeatBuilder (pcTravelClass as character):
        super(pcTravelClass).
    end constructor.

    method override protected ISeat GetInstance():
        define variable oSeat as ISeat no-undo.
        define variable lBluetooth as logical no-undo.
        define variable iScreenHeight as integer no-undo.
        define variable iScreenWidth as integer no-undo.
        define variable lScreenPiP as logical no-undo initial false.
        define variable lScreenTouch as logical no-undo initial false.
        define variable oScreenResolution as ResolutionEnum no-undo.
        define variable oJson as JsonObject no-undo.
        define variable oScreen as JsonObject no-undo.

        if not oConfig:Has(this-object:TravelClass) and not oConfig:GetType(this-object:TravelClass) = JsonDataType:OBJECT then
            undo, throw new AppError(substitute("&1 has no configuration", this-object:TravelClass), 0).

        oJson = oConfig:GetJsonObject(this-object:TravelClass).
        if oJson:Has("bt") and oJSon:GetType("bt") = JsonDataType:BOOLEAN then
            lBluetooth = oJson:GetLogical("bt").

        oSeat = new Seat(lBluetooth).

        if oJson:Has("screen") and oJson:GetType("screen") = JsonDataType:OBJECT then do:
            oScreen = oJson:GetJsonObject("screen").
            if oScreen:Has("h") and oScreen:GetType("h") = JsonDataType:NUMBER then
                iScreenHeight = oScreen:GetInteger("h").
            if oScreen:Has("w") and oScreen:GetType("w") = JsonDataType:NUMBER then
                iScreenWidth = oScreen:GetInteger("w").
            if oScreen:Has("res") and oScreen:GetType("res") = JsonDataType:STRING then
                oScreenResolution = ResolutionEnum:GetEnum(oScreen:GetCharacter("res")).

            if oScreen:Has("pip") and oScreen:GetType("pip") = JsonDataType:BOOLEAN then
                lScreenPiP = oScreen:GetLogical("pip").
            if oScreen:Has("touch") and oScreen:GetType("touch") = JsonDataType:BOOLEAN then
                lScreenTouch = oScreen:GetLogical("touch").

            oSeat = new SeatScreen(iScreenHeight,
                                   iScreenWidth,
                                   oScreenResolution,
                                   lScreenPiP,
                                   lScreenTouch,
                                   oSeat).
        end.

        /* Cast? */
        if oJson:Has("cast") and oJson:GetType("cast") = JsonDataType:BOOLEAN and oJson:GetLogical("cast") = true then
            oSeat = new SeatCast(oSeat).

        /* Controller? */
        if oJson:Has("controller") and oJson:GetType("controller") = JsonDataType:STRING then
            oSeat = new SeatControls(oJson:GetCharacter("controller"), oSeat).

        return oSeat.
    end method.

end class.
