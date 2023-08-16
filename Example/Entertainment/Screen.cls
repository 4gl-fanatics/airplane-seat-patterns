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
    File        : Screen
    Purpose     : A general screen
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk. Ltd.
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.* from propath.
using Example.Entertainment.* from propath.

class Example.Entertainment.Screen
    implements ISeatScreen:

    define variable iPipTopLeft as integer no-undo.

    define public property Height as integer no-undo
    get.
    private set.

    define public property Width as integer no-undo
    get.
    private set.

    define public property Resolution as ResolutionEnum no-undo
    get.
    private set.

    define public property SupportsPictureInPicture as logical no-undo
    get.
    private set.

    define public property SupportsTouch as logical no-undo
    get.
    private set.

    constructor public Screen(piHeight as integer,
                              piWidth as integer,
                              poResolution as ResolutionEnum,
                              plPip as logical,
                              plTouch as logical):

        this-object:Height = piHeight.
        this-object:Width  = piWidth.
        this-object:Resolution = poResolution.
        this-object:SupportsPictureInPicture = plPip.
        this-object:SupportsTouch = plTouch.

        iPipTopLeft = (this-object:Width * 0.85)
                    + (this-object:Height * 0.85).

    end constructor.

    method public void PlayPipChannel(poChannel as ChannelTypeEnum, pcId as character):

        if not this-object:SupportsPictureInPicture then
            message this-object:GetClass():TypeName + ':PlayPipChannel PiP not supported for this screen'.
        else if poChannel <> ChannelTypeEnum:Map and poChannel <> ChannelTypeEnum:Tv then do:
            message this-object:GetClass():TypeName + ':PlayPipChannel PiP not supported for this channel ' + string(poChannel).
        end.
        else do:
            message this-object:GetClass():TypeName + ':PlayPipChannel ' string(poChannel) pcId.

            this-object:PlayContent(iPipTopLeft, this-object:Width + this-object:Height, poChannel, pcId).
        end.

    end method.

    method public void PlayChannel(poChannel as ChannelTypeEnum, pcId as character):
        this-object:PlayContent(iPipTopLeft, this-object:Width + this-object:Height, poChannel, pcId).
    end method.

    method protected void PlayContent (piTopLeft as integer,
                                       piBottomRight as integer,
                                       poChannel as ChannelTypeEnum,
                                       pcId as character):
        /* get content from server, stream to area etc */
    end method.

end class.

