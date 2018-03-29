/* CadPack Plugin
 * Plugin created for Stak Design to speed up productivity.
 * This assembly combines custom command methods, existing commands, and resource LISP files
 * into one ribbon interface for quick selection and action.
 * (C) Copyright 2018 by  Zach Ayers
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Imaging;
using Autodesk.AutoCAD.ApplicationServices.Core;
using Autodesk.AutoCAD.Colors;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Runtime;
using Autodesk.Windows;
using CadPack;
using CadPack.Properties;
using Exception = Autodesk.AutoCAD.Runtime.Exception;

// This line is not mandatory, but improves loading performances

[assembly: CommandClass(typeof (MyCommands))]

namespace CadPack
{
    // This class is instantiated by AutoCAD for each document when
    // a command is called by the user the first time in the context
    // of a given document. In other words, non static data in this class
    // is implicitly per-document!

    public class MyCommands
    {
        // The CommandMethod attribute can be applied to any public  member 
        // function of any public class.
        // The function should take no arguments and return nothing.
        // If the method is an intance member then the enclosing class is 
        // intantiated for each document. If the member is a static member then
        // the enclosing class is NOT intantiated.
        //
        // NOTE: CommandMethod has overloads where you can provide helpid and
        // context menu.

        #region Layer Handling

        //Layer Lists - Used for Material Buttons and CAD layers
        private readonly List<Material> _rawPLyLayersList = new List<Material>();
        private readonly List<Material> _rawMdfLayers = new List<Material>();
        private readonly List<Material> _lamMdfLayers = new List<Material>();
        private readonly List<Material> _postLamLayerList = new List<Material>();
        private readonly List<Material> _pvcEdgeLayerList = new List<Material>();
        private readonly List<Material> _countertopLayerList = new List<Material>();
        private readonly List<Material> _steelLayerList = new List<Material>();
        private readonly List<Material> _sSteelLayerList = new List<Material>();
        private readonly List<Material> _tubeLayerList = new List<Material>();

        // Layer Objects
        // Uses the Material Constructor to create specific layers
        // for use by detailer.
        // First variable is the layer name, second variable is the color in CAD (refer color list numbers in CAD)
        //Plywood Layers

        private readonly Material _plywoodBending = new Material("Plywood - Bending (.35)", "30");
        private readonly Material _plywoodRawpt25 = new Material("Plywood - Raw (.25)", "20");
        private readonly Material _plywoodRawpt50 = new Material("Plywood - Raw (.50)", "110");
        private readonly Material _plywoodRawpt75 = new Material("Plywood - Raw (.75)", "41");

        //Raw MDF Layers
        private readonly Material _mdFpt125 = new Material("MDF - Raw (.125)", "204");
        private readonly Material _mdFpt25 = new Material("MDF - Raw (.25)", "196");
        private readonly Material _mdFpt3125 = new Material("MDF - Raw (.3125)", "113");
        private readonly Material _mdFpt375 = new Material("MDF - Raw (.375)", "21");
        private readonly Material _mdFpt50 = new Material("MDF - Raw (.50)", "142");
        private readonly Material _mdFpt625 = new Material("MDF - Raw (.625)", "42");
        private readonly Material _mdFpt75 = new Material("MDF - Raw (.75)", "151");
        private readonly Material _mdf1Pt0 = new Material("MDF - Raw (1.0)", "112");

        //Post Lam MDF Layers
        private readonly Material _lamMdFpt5625Grain = new Material("MDF Laminated - xxx (.5625) - Grain", "55");
        private readonly Material _lamMdFpt8125Grain = new Material("MDF Laminated - xxx (.8125) - Grain", "14");
        private readonly Material _lamMdFpt875Grain = new Material("MDF Laminated - xxx (.875) - Grain", "33");
        private readonly Material _lamMdf1Pt125Grain = new Material("MDF Laminated - xxx (1.125) - Grain", "170");

        private readonly Material _lamMdFpt5625Solid = new Material("MDF Laminated - xxx (.5625) - Solid", "105");
        private readonly Material _lamMdFpt8125Solid = new Material("MDF Laminated - xxx (.8125) - Solid", "252");
        private readonly Material _lamMdFpt875Solid = new Material("MDF Laminated - xxx (.875) - Solid", "96");
        private readonly Material _lamMdf1Pt125Solid = new Material("MDF Laminated - xxx (1.125) - Solid", "174");

        //Post Lam Layers
        private readonly Material _postLaminateGrain = new Material("Post Laminate - xxx - Grain", "14");
        private readonly Material _postLaminateSolid = new Material("Post Laminate - xxx - Solid", "252");

        // PVC Edge Layers
        private readonly Material _pvcEdge1 = new Material("PVC Edge - xxx (.02) .5MM", "71");
        private readonly Material _pvcEdge2 = new Material("PVC Edge - xxx (.04) 1MM", "72");
        private readonly Material _pvcEdge3 = new Material("PVC Edge - xxx (.125) 3MM", "41");

        //Countertop Layers
        private readonly Material _countertop1 = new Material("Countertop - Dark (.50)", "185");
        private readonly Material _countertop2 = new Material("Countertop - Light (.50)", "253");

        //Steel Layers
        private readonly Material _steel1 = new Material("Steel Plate (.1875)", "124");
        private readonly Material _steel2 = new Material("Steel Plate (.125)", "14");
        private readonly Material _steel3 = new Material("Steel Plate (.25)", "141");
        private readonly Material _steel4 = new Material("Steel Plate - 11 Gauge", "85");
        private readonly Material _steel5 = new Material("Steel Plate - 12 Gauge", "225");
        private readonly Material _steel6 = new Material("Steel Plate - 13 Gauge", "202");
        private readonly Material _steel7 = new Material("Steel Plate - 14 Gauge", "136");
        private readonly Material _steel8 = new Material("Steel Plate - 16 Gauge", "145");
        private readonly Material _steel9 = new Material("Steel Plate - 18 Gauge", "84");
        private readonly Material _steel10 = new Material("Steel Plate - 20 Gauge", "54");

        private readonly Material _sSteel1 = new Material("S. Steel Plate (.1875)", "130");
        private readonly Material _sSteel2 = new Material("S. Steel Plate (.125)", "151");
        private readonly Material _sSteel3 = new Material("S. Steel Plate (.25)", "17");
        private readonly Material _sSteel4 = new Material("S. Steel Plate - 11 Gauge", "83");
        private readonly Material _sSteel5 = new Material("S. Steel Plate - 12 Gauge", "30");
        private readonly Material _sSteel6 = new Material("S. Steel Plate - 13 Gauge", "201");
        private readonly Material _sSteel7 = new Material("S. Steel Plate - 14 Gauge", "136");
        private readonly Material _sSteel8 = new Material("S. Steel Plate - 16 Gauge", "170");
        private readonly Material _sSteel9 = new Material("S. Steel Plate - 18 Gauge", "155");
        private readonly Material _sSteel10 = new Material("S. Steel Plate - 20 Gauge", "52");

        //Tube Layers
        private readonly Material _tube1 = new Material("Steel Tube - 11 Gauge", "193");
        private readonly Material _tube2 = new Material("Steel Tube - 13 Gauge", "120");
        private readonly Material _tube3 = new Material("Steel Tube - 14 Gauge", "132");
        private readonly Material _tube4 = new Material("Steel Tube - 16 Gauge", "140");

        //Init Layers - Adds all layers to the layer lists
        private void InitLayers()
        {
            _rawPLyLayersList.Add(_plywoodBending);
            _rawPLyLayersList.Add(_plywoodRawpt25);
            _rawPLyLayersList.Add(_plywoodRawpt50);
            _rawPLyLayersList.Add(_plywoodRawpt75);

            _rawMdfLayers.Add(_mdFpt125);
            _rawMdfLayers.Add(_mdFpt25);
            _rawMdfLayers.Add(_mdFpt3125);
            _rawMdfLayers.Add(_mdFpt375);
            _rawMdfLayers.Add(_mdFpt50);
            _rawMdfLayers.Add(_mdFpt625);
            _rawMdfLayers.Add(_mdFpt75);
            _rawMdfLayers.Add(_mdf1Pt0);

            _lamMdfLayers.Add(_lamMdFpt5625Grain);
            _lamMdfLayers.Add(_lamMdFpt8125Grain);
            _lamMdfLayers.Add(_lamMdFpt875Grain);
            _lamMdfLayers.Add(_lamMdf1Pt125Grain);
            _lamMdfLayers.Add(_lamMdFpt5625Solid);
            _lamMdfLayers.Add(_lamMdFpt8125Solid);
            _lamMdfLayers.Add(_lamMdFpt875Solid);
            _lamMdfLayers.Add(_lamMdf1Pt125Solid);

            _postLamLayerList.Add(_postLaminateGrain);
            _postLamLayerList.Add(_postLaminateSolid);

            _pvcEdgeLayerList.Add(_pvcEdge1);
            _pvcEdgeLayerList.Add(_pvcEdge2);
            _pvcEdgeLayerList.Add(_pvcEdge3);

            _countertopLayerList.Add(_countertop1);
            _countertopLayerList.Add(_countertop2);

            _steelLayerList.Add(_steel1);
            _steelLayerList.Add(_steel2);
            _steelLayerList.Add(_steel3);
            _steelLayerList.Add(_steel4);
            _steelLayerList.Add(_steel5);
            _steelLayerList.Add(_steel6);
            _steelLayerList.Add(_steel7);
            _steelLayerList.Add(_steel8);
            _steelLayerList.Add(_steel9);
            _steelLayerList.Add(_steel10);

            _sSteelLayerList.Add(_sSteel1);
            _sSteelLayerList.Add(_sSteel2);
            _sSteelLayerList.Add(_sSteel3);
            _sSteelLayerList.Add(_sSteel4);
            _sSteelLayerList.Add(_sSteel5);
            _sSteelLayerList.Add(_sSteel6);
            _sSteelLayerList.Add(_sSteel7);
            _sSteelLayerList.Add(_sSteel8);
            _sSteelLayerList.Add(_sSteel9);
            _sSteelLayerList.Add(_sSteel10);

            _tubeLayerList.Add(_tube1);
            _tubeLayerList.Add(_tube2);
            _tubeLayerList.Add(_tube3);
            _tubeLayerList.Add(_tube4);
        }

        #endregion

        #region Commands

        #region Creation Commands

        //Todo

        #endregion

        #region Annotation Commands

        // Edits the Suffix Of Dimensions
        // Adds Suffixes such as 'O.D.', 'I.D.', 'TYP.' to dimension text.
        // Can also reset dimension text back to its default value.
        [CommandMethod("CPack_DimValueEdit", CommandFlags.Modal | CommandFlags.Redraw)]
        public void ResetDims()
        {
            // Inititate Document & Editor
            var doc = Application.DocumentManager.MdiActiveDocument;
            var ed = doc.Editor;
            var db = doc.Database;

            //Create a selection filter of DIMENSION
            var values = new[] { new TypedValue(0, "DIMENSION") };
            var filter = new SelectionFilter(values);

            //Prompt User for input
            var opts = new PromptSelectionOptions
            {
                MessageForRemoval = "\nMust be a type of Dimension!",
                MessageForAdding = "\nSelect dimensions to edit : ",
                PrepareOptionalDetails = false,
                SingleOnly = false,
                SinglePickInSpace = false,
                AllowDuplicates = true
            };

            var result = ed.GetSelection(opts, filter);
            if (result.Status != PromptStatus.OK) return;
            try
            {
                // Prompt user to select suffix
                var pKeyOpts = new PromptKeywordOptions("") { Message = "\nEnter Dimension Edit Option " };
                pKeyOpts.Keywords.Add("OD");
                pKeyOpts.Keywords.Add("ID");
                pKeyOpts.Keywords.Add("TYP");
                pKeyOpts.Keywords.Add("Reset");
                pKeyOpts.AllowNone = false;

                var pKeyRes = ed.GetKeywords(pKeyOpts);

                if (pKeyRes.Status != PromptStatus.OK) return;

                // Add Suffix to dimensions and close transaction
                using (var tr = db.TransactionManager.StartTransaction())
                {
                    var sset = result.Value;
                    var transaction = tr;
                  
                    foreach (var dim in (from SelectedObject selobj in sset where transaction != null select transaction.GetObject(selobj.ObjectId, OpenMode.ForWrite, false) into obj select obj).OfType<Dimension>())
                    {
                        switch (pKeyRes.StringResult)
                        {
                            case "OD":
                                dim.DimensionText = "<> O.D.";
                                break;
                            case "ID":
                                dim.DimensionText = "<> I.D.";
                                break;
                            case "Typ":
                                dim.DimensionText = "<> TYP.";
                                break;
                            case "Reset":
                                dim.DimensionText = "<>";
                                break;
                            default:
                                return;
                        }                        
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("\nProblem updating dimensions.\n");
                ed.WriteMessage(ex.Message);
            }
        }

        // Removes Extension Lines from Selected Dimensions
        [CommandMethod("CPack_DimRemoveExtLines", CommandFlags.Modal | CommandFlags.Redraw)]
        public void DimRemoveExtLines()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            var ed = doc.Editor;
            var db = doc.Database;
            var values = new[] { new TypedValue(0, "DIMENSION") };
            var filter = new SelectionFilter(values);
            var opts = new PromptSelectionOptions
            {                
                PrepareOptionalDetails = false,
                SingleOnly = false,
                SinglePickInSpace = false,
                AllowDuplicates = true
            };

            var result = ed.GetSelection(opts, filter);
            if (result.Status != PromptStatus.OK) return;
            try
            {
                using (var tr = db.TransactionManager.StartTransaction())
                {
                    var sset = result.Value;
                    var transaction = tr;

                    foreach (var dim in (from SelectedObject selobj in sset where transaction != null select transaction.GetObject(selobj.ObjectId, OpenMode.ForWrite, false) into obj select obj).OfType<Dimension>())
                    {
                        dim.Dimse1 = true;
                        dim.Dimse2 = true; 
                                           
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("\nProblem updating dimensions.\n");
                ed.WriteMessage(ex.Message);
            }
        }

        // Removes Dimension Lines from Selected Dimensions
        [CommandMethod("CPack_DimRemoveDimLines", CommandFlags.Modal | CommandFlags.Redraw)]
        public void DimRemoveDimLines()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            var ed = doc.Editor;
            var db = doc.Database;
            var values = new[] { new TypedValue(0, "DIMENSION") };
            var filter = new SelectionFilter(values);
            var opts = new PromptSelectionOptions
            {
                PrepareOptionalDetails = false,
                SingleOnly = false,
                SinglePickInSpace = false,
                AllowDuplicates = true
            };

            var result = ed.GetSelection(opts, filter);
            if (result.Status != PromptStatus.OK) return;
            try
            {
                using (var tr = db.TransactionManager.StartTransaction())
                {
                    var sset = result.Value;
                    var transaction = tr;

                    foreach (var dim in (from SelectedObject selobj in sset where transaction != null select transaction.GetObject(selobj.ObjectId, OpenMode.ForWrite, false) into obj select obj).OfType<Dimension>())
                    {
                        dim.Dimsd1 = true;
                        dim.Dimsd2 = true;
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("\nProblem updating  dimensions.\n");
                ed.WriteMessage(ex.Message);
            }
        }

        // Removes Arrows from Selected Dimensions
        [CommandMethod("CPack_DimRemoveArrows", CommandFlags.Modal | CommandFlags.Redraw)]
        public void DimRemoveArrows()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            var ed = doc.Editor;
            var db = doc.Database;
            var values = new[] { new TypedValue(0, "DIMENSION") };
            var filter = new SelectionFilter(values);
            var opts = new PromptSelectionOptions
            {
                PrepareOptionalDetails = false,
                SingleOnly = false,
                SinglePickInSpace = false,
                AllowDuplicates = true
            };

            var result = ed.GetSelection(opts, filter);
            if (result.Status != PromptStatus.OK) return;
            try
            {
                using (var tr = db.TransactionManager.StartTransaction())
                {
                    var sset = result.Value;
                    var transaction = tr;

                    foreach (var dim in (from SelectedObject selobj in sset where transaction != null select transaction.GetObject(selobj.ObjectId, OpenMode.ForWrite, false) into obj select obj).OfType<Dimension>())
                    {
                        dim.Dimasz = 0;                        
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("\nProblem updating  dimensions.\n");
                ed.WriteMessage(ex.Message);
            }
        }
        #endregion

        #region Cleanup Commands

        //Cleanup DWG
        [CommandMethod("CPack_CleanupDWG", CommandFlags.Modal)]
        public void CPackCleanupDwg()
        {          
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;

            // Calls various Cpack_cleanup functions      
            CPackIsolineFix();
            CPackLineweightFix();
            CPackCleanAllSolids();
            CPackViewportPrep();
            CPackPurge();
            CPackAudit();
        }

        //Purge
        [CommandMethod("CPack_Purge", CommandFlags.Modal)]
        public void CPackPurge()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;

            ed.WriteMessage("\nDrawing will now be purged.\n");

            ed.Command("._-Purge", "A", "*", "N");
            ed.Command("._-Purge", "R", "*", "N");

            ed.WriteMessage("\nDrawing has been purged.\n");
        }

        //Audit
        [CommandMethod("CPack_Audit", CommandFlags.Modal)]
        public void CPackAudit()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;

            ed.WriteMessage("\nDrawing will now be audited and all errors fixed.\n");

            ed.Command("._Audit", "Y");

            ed.WriteMessage("\nDrawing has been audited.\n");
        }


        //Isoline Fix
        [CommandMethod("CPack_IsolineFix", CommandFlags.Modal)]
        public void CPackIsolineFix()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;

            ed.WriteMessage("\nIsoline representation will be set to the default of 4.\n");

            ed.Command("._Isolines", "4");
            ed.Command("._Regenall");

            ed.WriteMessage("\nIsoline representation has been corrected.\n");
        }

        //Lineweight Fix
        [CommandMethod("CPack_LineweightFix", CommandFlags.Modal)]
        public void CPackLineweightFix()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;

            ed.WriteMessage("\nAll Layer Lineweights will be set to 'Default'\n");

            ed.Command("_.-layer", "lw", "default", "*", "");

            ed.WriteMessage("\nLineweight representation has been corrected.\n");
        }

        //Viewport Preparation
        [CommandMethod("Cpack_ViewportPreparation", CommandFlags.Modal)]
        public void CPackViewportPrep()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;
            var db = doc.Database;

            ed.Command("._-layer", "make", "DEFPOINTS", "");

            using (var tr = db.TransactionManager.StartTransaction())
            {
                var layoutMgr = LayoutManager.Current;
                var prevLayout = layoutMgr.CurrentLayout;

                DBDictionary layoutDict;

                using (layoutDict = tr.GetObject(db.LayoutDictionaryId, OpenMode.ForRead) as DBDictionary)

                {
                    var visualStlyeDic = (DBDictionary) tr.GetObject(db.VisualStyleDictionaryId, OpenMode.ForRead);
                    var visualStyleId = visualStlyeDic.GetAt("2DWireframe");

                    Debug.Assert(layoutDict != null, "layoutDict != null");
                    foreach (DictionaryEntry layoutEntry in layoutDict)
                    {
                        Layout layoutObj;

                        using (layoutObj = tr.GetObject((ObjectId) (layoutEntry.Value), OpenMode.ForRead) as Layout)
                        {
                            if (layoutObj != null && layoutObj.LayoutName != "Model")
                                layoutMgr.CurrentLayout = layoutObj.LayoutName;

                            Debug.Assert(layoutObj != null, "layoutObj != null");
                            var r = tr.GetObject(layoutObj.BlockTableRecordId, OpenMode.ForRead) as BlockTableRecord;

                            if (r != null)
                                foreach (var obj in r)
                                {
                                    var dbobj = tr.GetObject(obj, OpenMode.ForRead);
                                    var vp = dbobj as Viewport;
                                    if (vp == null) continue;
                                    vp.UpgradeOpen();
                                    vp.Layer = "DEFPOINTS";
                                    vp.VisualStyleId = visualStyleId;
                                    vp.ShadePlot = ShadePlotType.Hidden;
                                    vp.Locked = true;
                                    vp.On = true;
                                    vp.UpdateDisplay();
                                }

                            layoutMgr.CurrentLayout = prevLayout;
                            ed.WriteMessage("\nViewport Representations Updated.\n");
                        }
                    }

                    tr.Commit();
                }
            }

            ed.Command("._-layer", "set", "0", "");
        }

        //Clean Solids
        [CommandMethod("CPack_CleanSolids")]
        public void CPackCleanAllSolids()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;
            var db = doc.Database;

            using (var tr = db.TransactionManager.StartTransaction())
            {
                try
                {
                    // Create a TypedValue array to define the filter criteria
                    var acTypValAr = new TypedValue[1];
                    acTypValAr.SetValue(new TypedValue((int) DxfCode.Start, "3DSOLID"), 0);

                    // Assign the filter criteria to a SelectionFilter object
                    var acSelFtr = new SelectionFilter(acTypValAr);

                    // Request for objects to be selected in the drawing area
                    var acSsPrompt = ed.SelectAll(acSelFtr);

                    // If the prompt status is OK, objects were selected
                    if (acSsPrompt.Status == PromptStatus.OK)
                    {
                        var acSSet = acSsPrompt.Value;

                        ed.WriteMessage("\nNumber of Solids to be cleaned: " + acSSet.Count);

                        foreach (SelectedObject obj in acSSet)
                        {
                            var en = (Entity) tr.GetObject(obj.ObjectId, OpenMode.ForWrite);
                            var sol3D = en as Solid3d;
                            Debug.Assert(sol3D != null, "sol3D != null");
                            sol3D.CleanBody();
                        }

                        ed.WriteMessage("\nAll Solids have been cleaned.\n");
                    }
                    else
                    {
                        ed.WriteMessage("\nNo Solid bodies exist in drawing. Are they in blocks?\n");
                    }

                    tr.Commit();
                }

                catch (Exception ex)
                {
                    Application.ShowAlertDialog(ex.Message);
                }
            }
        }

        //Select 2D Elements
        [CommandMethod("CPack_Select2DElements")]
        public void CPackSelect2DElements()
        {
            SelectObjectSet("*LINE,CIRCLE,ARC,ELLIPSE,POINT,RAY");
        }

        //Select Annotations
        [CommandMethod("CPack_SelectAnnoElements")]
        public void CPackSelectAnnoElements()
        {
            SelectObjectSet("*DIMENSION,*TEXT,*LEADER,*TABLE");
        }

        //Select Blocks
        [CommandMethod("CPack_SelectBlockElements")]
        public void CPackSelectBlockElements()
        {
            SelectObjectSet("INSERT");
        }

        //Select Hatches
        [CommandMethod("CPack_SelectHatchElements")]
        public void CPackSelectHatchElements()
        {
            SelectObjectSet("HATCH");
        }

        // Select Objects Method
        public void SelectObjectSet(string entValues)
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;
            var db = doc.Database;

            using (var tr = db.TransactionManager.StartTransaction())
            {
                try
                {
                    // Create a TypedValue array to define the filter criteria
                    var acTypValAr = new TypedValue[1];
                    acTypValAr.SetValue(new TypedValue((int) DxfCode.Start, entValues), 0);

                    // Assign the filter criteria to a SelectionFilter object
                    var acSelFtr = new SelectionFilter(acTypValAr);

                    // Request for objects to be selected in the drawing area
                    var acSsPrompt = ed.SelectAll(acSelFtr);

                    // If the prompt status is OK, objects were selected
                    if (acSsPrompt.Status == PromptStatus.OK)
                    {
                        var acSSet = acSsPrompt.Value;
                        ed.SetImpliedSelection(acSSet);
                    }
                    else
                    {
                        ed.WriteMessage("\nNone exist in drawing.\n");
                    }

                    tr.Commit();
                }

                catch (Exception ex)
                {
                    Application.ShowAlertDialog(ex.Message);
                }
            }
        }

        //Layout - Delete All Layouts
        [CommandMethod("Cpack_DeleteAllLayouts", CommandFlags.Modal)]
        public void CPackDeleteAllLayouts()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;
            var db = doc.Database;

            using (var tr = db.TransactionManager.StartTransaction())
            {
                var layoutMgr = LayoutManager.Current;
                DBDictionary layoutDict;

                using (layoutDict = tr.GetObject(db.LayoutDictionaryId, OpenMode.ForRead) as DBDictionary)

                {
                    Debug.Assert(layoutDict != null, "layoutDict != null");
                    foreach (DictionaryEntry layoutEntry in layoutDict)
                    {
                        Layout layoutObj;

                        using (layoutObj = tr.GetObject((ObjectId) (layoutEntry.Value), OpenMode.ForRead) as Layout)
                        {
                            if (layoutObj != null && layoutObj.LayoutName != "Model")
                                layoutMgr.DeleteLayout(layoutObj.LayoutName);
                        }
                    }

                    layoutMgr.CurrentLayout = "Model";
                    tr.Commit();
                    ed.WriteMessage("\nAll Layouts Deleted.\n");
                }
            }
        }

        //Layout - Delete Other Layouts
        [CommandMethod("Cpack_DeleteOtherLayouts", CommandFlags.Modal)]
        public void CPackDeleteOtherLayouts()
        {
            var doc = Application.DocumentManager.MdiActiveDocument;
            if (doc == null) return;
            var ed = doc.Editor;
            var db = doc.Database;

            using (var tr = db.TransactionManager.StartTransaction())
            {
                var layoutMgr = LayoutManager.Current;
                var curLayout = layoutMgr.CurrentLayout;

                DBDictionary layoutDict;

                using (layoutDict = tr.GetObject(db.LayoutDictionaryId, OpenMode.ForRead) as DBDictionary)

                {
                    Debug.Assert(layoutDict != null, "layoutDict != null");
                    foreach (DictionaryEntry layoutEntry in layoutDict)
                    {
                        Layout layoutObj;

                        using (layoutObj = tr.GetObject((ObjectId) (layoutEntry.Value), OpenMode.ForRead) as Layout)
                        {
                            Debug.Assert(layoutObj != null, "layoutObj != null");
                            if (layoutObj.LayoutName != curLayout && layoutObj.LayoutName != "Model")
                                layoutMgr.DeleteLayout(layoutObj.LayoutName);
                        }
                    }

                    tr.Commit();
                    ed.WriteMessage("\nOther Layouts Deleted.\n");
                }
            }
        }

        #region Tool Methods

        public static string BytesToString(long byteCount)
        {
            string[] suf = {"B", "KB", "MB", "GB", "TB", "PB", "EB"}; //Longs run out around EB
            if (byteCount == 0)
                return "0" + suf[0];
            var bytes = Math.Abs(byteCount);
            var place = Convert.ToInt32(Math.Floor(Math.Log(bytes, 1024)));
            var num = Math.Round(bytes/Math.Pow(1024, place), 1);
            return (Math.Sign(byteCount)*num) + suf[place];
        }

        #endregion

        #endregion

        #endregion

        #region Ribbon

        //Creates CPack Ribbon
        //Can be invoked during other commands
        [CommandMethod("CPack_Ribbon", CommandFlags.Transparent)]
        public void CPack_Ribbon()
        {
            // Define ribbon properties
            const string rTabId = "CadPack";
            const string rTabTitle = "CadPack";
            const bool rTabContextual = false;

            try
            {
                InitLayers();

                //Create Ribbon Control
                var ribbonControl = ComponentManager.Ribbon;

                if (ribbonControl == null) return;
                var rTab = ribbonControl.FindTab(rTabId);
                if (rTab != null)
                {
                    rTab.IsActive = true;
                }
                else
                {
                    // Create Cad Pack Ribbon Tab
                    rTab = new RibbonTab
                    {
                        Title = rTabTitle,
                        Id = rTabId
                    };

                    // Add Tab To Ribbon
                    ribbonControl.Tabs.Add(rTab);
                    rTab.IsActive = true;
                    rTab.IsContextualTab = rTabContextual;
                    rTab.IsVisible = true;

                    //Create Ribbon Panels
                    var creationPanelSource = new RibbonPanelSource {Title = "Create"};
                    var creationPanel = new RibbonPanel
                    {
                        Source = creationPanelSource,
                    };

                    var editPanelSource = new RibbonPanelSource {Title = "Edit"};
                    var editPanel = new RibbonPanel
                    {
                        Source = editPanelSource,
                    };

                    var materialPanelSource = new RibbonPanelSource {Title = "Materials"};
                    var materialPanel = new RibbonPanel
                    {
                        Source = materialPanelSource,
                    };

                    var annotationPanelSource = new RibbonPanelSource {Title = "Annotation"};
                    var annotationPanel = new RibbonPanel
                    {
                        Source = annotationPanelSource,
                    };

                    var inspectPanelSource = new RibbonPanelSource {Title = "Inspect"};
                    var inspectPanel = new RibbonPanel
                    {
                        Source = inspectPanelSource,
                    };

                    var cleanupPanelSource = new RibbonPanelSource {Title = "Cleanup"};
                    var cleanupPanel = new RibbonPanel
                    {
                        Source = cleanupPanelSource,
                    };

                    //Add Panels To Ribbon Tab
                    rTab.Panels.Add(creationPanel);                 
                    rTab.Panels.Add(editPanel);
                    rTab.Panels.Add(annotationPanel);
                    rTab.Panels.Add(inspectPanel);
                    rTab.Panels.Add(materialPanel);
                    rTab.Panels.Add(cleanupPanel);

                    #region Creation Panel Contents

                    //----Creation Panel----//

                    var cPackCreateSolid = new RibbonSplitButton
                    {
                        Text = "Solid\nBodies",
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image,
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large
                    };

                    var cPackCreatePolySolid = new RibbonButton()
                    {
                        Text = "Polysolid",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Polysolid_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Polysolid",
                        ToolTip = "Create Box",
                    };

                    var cPackCreateBox = new RibbonButton()
                    {
                        Text = "Box",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Box_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Box",
                        ToolTip = "Create Box",
                    };

                    var cPackCreateCyl = new RibbonButton()
                    {
                        Text = "Cylinder",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Cylinder_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Cylinder",
                        ToolTip = "Create Cylinder",
                    };

                    var cPackCreateSphere = new RibbonButton()
                    {
                        Text = "Sphere",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Sphere_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Sphere",
                        ToolTip = "Create Sphere",
                    };

                    var cPackCreateCone = new RibbonButton()
                    {
                        Text = "Cone",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Cone_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Cone",
                        ToolTip = "Create Cone",
                    };

                    cPackCreateSolid.Items.Add(cPackCreatePolySolid);
                    cPackCreateSolid.Items.Add(cPackCreateBox);
                    cPackCreateSolid.Items.Add(cPackCreateCyl);
                    cPackCreateSolid.Items.Add(cPackCreateSphere);
                    cPackCreateSolid.Items.Add(cPackCreateCone);

                    var cPackCreateSteel = new RibbonButton
                    {
                        Text = "Steel\nMill",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CadPack_Steel_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_SteelMill",
                        ToolTip = "Create Steel Member",
                    };

                    var cPackCreateFastener = new RibbonButton
                    {
                        Text = "Fastener\nBin",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CadPack_Fasteners_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_Fasteners",
                        ToolTip = "Create Fastener",
                    };

                    var cPackCreateWeld = new RibbonButton
                    {
                        Text = "Weld\nTable",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CadPack_Weld_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_Weld",
                        ToolTip = "Create Weld Symbol",
                    };

                    var createRowPanel1 = new RibbonRowPanel();
                    createRowPanel1.Items.Add(cPackCreateSolid);
                    createRowPanel1.Items.Add(cPackCreateSteel);
                    createRowPanel1.Items.Add(cPackCreateFastener);
                    createRowPanel1.Items.Add(cPackCreateWeld);

                    creationPanel.Items.Add(createRowPanel1);

                    #endregion

                    #region Edit Panel Contents

                    //----Edit Panel----//

                    var editButtonPresspull = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_PressPull_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Presspull",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._presspull"
                    };

                    var editButtonExtrude = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Extrude_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Extrude",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._extrude"
                    };

                    var editButtonExtrudeFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_ExtrudeFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Extrude Faces",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _extrude"
                    };

                    var editButtonOffsetFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_OffsetFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Offset Faces",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _offset"
                    };

                    var editButtonSweep = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Sweep_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Sweep",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_sweep"
                    };

                    var editButtonRevolve = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Revolve_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Revolve",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_revolve"
                    };

                    var editButtonLoft = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Loft_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Loft",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_loft"
                    };

                    var editButtonShell = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Shell_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Shell",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _body _shell"
                    };

                    var editButtonSlice = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Slice_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Slice",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_ASL"
                    };

                    var editButtonDadoJoint = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DadoJoint_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dado Joint",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_DDJ"
                    };

                    var editButtonCrossPiece = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_CrossPiece_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Cross Piece",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_CRS"
                    };

                    var editButtonMoveFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MoveFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Move Face",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _move"
                    };

                    var editButtonDeleteFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DeleteFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Delete Face",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _delete"
                    };

                    var editButtonRotateFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_RotateFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Rotate Face",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _rotate"
                    };

                    var editButtonTaperFace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_TaperFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Taper Face",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _face _taper"
                    };

                    var editButtonSelectVerts = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectVerts_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Select Vertices",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_subobjselectionmode 1"
                    };

                    var editButtonSelectEdges = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectEdge_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Select Edges",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_subobjselectionmode 2"
                    };


                    var editButtonSelectFaces = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectFace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Select Faces",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_subobjselectionmode 3"
                    };

                    var editButtonSelectNoFilter = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectNoFilter_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "No Filter",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_subobjselectionmode 0"
                    };

                    var editButtonAvcFixture = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Fixture_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Fixture",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Fixture"
                    };

                    var editButtonChop = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Chop_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Chop",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_CH"
                    };

                    var editButtonDivide = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Divide_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Divide",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_CHE"
                    };

                    var editButtonGap = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Gap_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Gap",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_gap"
                    };

                    var editButtonUnion = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Union_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Union",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_union"
                    };

                    var editButtonSubtract = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Subtract_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Subtract",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_subtract"
                    };

                    var editButtonIntersect = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Intersect_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Intersect",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_intersect"
                    };

                    var editButtonFilletEdge = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_FilletEdge_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Fillet Edge",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_filletedge"
                    };

                    var editButtonChamferEdge = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_ChamferEdge_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Chamfer Edge",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_chamferedge"
                    };

                    var editButtonKnife = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Knife_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Slice",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_slice"
                    };

                    var editButtonSeparate = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Seperate_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Separate Solids",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_solidedit _body _separate"
                    };

                    var editButtonXedges = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_XEdges_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Extract Edges",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_xedges"
                    };

                    var editButtonOffsetEdges = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_OffsetEdge_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "OffsetEdges",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_offsetedge"
                    };

                    var editButtonInterfere = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Interfere_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Check Interference",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "_interfere"
                    };


                    //Add Buttons To Edit Panel
                    var editPanelRow1 = new RibbonRowPanel();
                    editPanelRow1.Items.Add(editButtonPresspull);
                    editPanelRow1.Items.Add(editButtonExtrude);
                    editPanelRow1.Items.Add(editButtonExtrudeFace);
                    editPanelRow1.Items.Add(editButtonOffsetFace);
                    editPanelRow1.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow1.Items.Add(editButtonSweep);
                    editPanelRow1.Items.Add(editButtonRevolve);
                    editPanelRow1.Items.Add(editButtonLoft);
                    editPanelRow1.Items.Add(editButtonShell);
                    editPanelRow1.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow1.Items.Add(editButtonSlice);
                    editPanelRow1.Items.Add(editButtonDadoJoint);
                    editPanelRow1.Items.Add(editButtonCrossPiece);

                    var editPanelRow2 = new RibbonRowPanel();
                    editPanelRow2.Items.Add(editButtonMoveFace);
                    editPanelRow2.Items.Add(editButtonDeleteFace);
                    editPanelRow2.Items.Add(editButtonRotateFace);
                    editPanelRow2.Items.Add(editButtonTaperFace);
                    editPanelRow2.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow2.Items.Add(editButtonSelectVerts);
                    editPanelRow2.Items.Add(editButtonSelectEdges);
                    editPanelRow2.Items.Add(editButtonSelectFaces);
                    editPanelRow2.Items.Add(editButtonSelectNoFilter);
                    editPanelRow2.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow2.Items.Add(editButtonAvcFixture);
                    editPanelRow2.Items.Add(editButtonChop);
                    editPanelRow2.Items.Add(editButtonDivide);

                    var editPanelRow3 = new RibbonRowPanel();
                    editPanelRow3.Items.Add(editButtonGap);
                    editPanelRow3.Items.Add(editButtonUnion);
                    editPanelRow3.Items.Add(editButtonSubtract);
                    editPanelRow3.Items.Add(editButtonIntersect);
                    editPanelRow3.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow3.Items.Add(editButtonFilletEdge);
                    editPanelRow3.Items.Add(editButtonChamferEdge);
                    editPanelRow3.Items.Add(editButtonKnife);
                    editPanelRow3.Items.Add(editButtonSeparate);
                    editPanelRow3.Items.Add(new RibbonSeparator {SeparatorStyle = RibbonSeparatorStyle.Line});
                    editPanelRow3.Items.Add(editButtonXedges);
                    editPanelRow3.Items.Add(editButtonOffsetEdges);
                    editPanelRow3.Items.Add(editButtonInterfere);

                    editPanel.Items.Add(editPanelRow1);
                    editPanel.Items.Add(new RibbonRowBreak());
                    editPanel.Items.Add(editPanelRow2);
                    editPanel.Items.Add(new RibbonRowBreak());
                    editPanel.Items.Add(editPanelRow3);

                    #endregion

                    #region Material Panel Contents

                    var rawMdfMatSplitButton = new RibbonSplitButton
                    {
                        Text = "Raw MDF",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_rawMdfLayers, rawMdfMatSplitButton);

                    var lamMdfMatSplitButton = new RibbonSplitButton
                    {
                        Text = "Lam MDF",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_lamMdfLayers, lamMdfMatSplitButton);

                    var rawPlyMatSplitButton = new RibbonSplitButton
                    {
                        Text = "Raw Ply",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_rawPLyLayersList, rawPlyMatSplitButton);

                    var postLamSplitButton = new RibbonSplitButton
                    {
                        Text = "Post Lam",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_postLamLayerList, postLamSplitButton);

                    var pvcEdgeSplitButton = new RibbonSplitButton
                    {
                        Text = "PVC Edge",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_pvcEdgeLayerList, pvcEdgeSplitButton);

                    var counterTopSplitButton = new RibbonSplitButton
                    {
                        Text = "Countertop",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_countertopLayerList, counterTopSplitButton);

                    var steelPlateSplitButton = new RibbonSplitButton
                    {
                        Text = "Steel",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_steelLayerList, steelPlateSplitButton);

                    var sSteelPlateSplitButton = new RibbonSplitButton
                    {
                        Text = "S. Steel",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_sSteelLayerList, sSteelPlateSplitButton);

                    var steelTubeSplitButton = new RibbonSplitButton
                    {
                        Text = "Tubing",
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image
                    };

                    CreateMatButton(_tubeLayerList, steelTubeSplitButton);

                    var matPanelRow1 = new RibbonRowPanel();

                    matPanelRow1.Items.Add(rawPlyMatSplitButton);
                    matPanelRow1.Items.Add(rawMdfMatSplitButton);
                    matPanelRow1.Items.Add(lamMdfMatSplitButton);
                    matPanelRow1.Items.Add(postLamSplitButton);
                    matPanelRow1.Items.Add(pvcEdgeSplitButton);
                    matPanelRow1.Items.Add(counterTopSplitButton);
                    matPanelRow1.Items.Add(steelPlateSplitButton);
                    matPanelRow1.Items.Add(sSteelPlateSplitButton);
                    matPanelRow1.Items.Add(steelTubeSplitButton);

                    materialPanel.Items.Add(matPanelRow1);

                    #endregion

                    #region Annotation Panel Contents

                    //----Annotation Panel----//

                    var annoButtonBaseView = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_BaseView_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Base View",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._viewbase _m"
                    };

                    var annoButtonProjectView = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_ProjectView_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Project View",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._viewproj"
                    };

                    var annoButtonSectionView = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SectionView_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Section View",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._viewsection"
                    };

                    var annoButtonDetailView = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DetailView_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Detail View",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._viewdetail"
                    };

                    var annoButtonDimLinear = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimLinear_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Linear Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimlinear"
                    };

                    var annoButtonDimAligned = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimAligned_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Aligned Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimaligned"
                    };

                    var annoButtonDimAngular = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimAngular_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Angular Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimangular"
                    };

                    var annoButtonDimDiam = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimDiam_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Diameter Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimdiameter"
                    };

                    var annoButtonDimArc = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.Arc_Dimension),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Arc Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimarc"
                    };

                    var annoButtonDimJogged = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.Jogged_Dimension),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Jogged Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimjogged"
                    };

                    var annoButtonDimOrdinate = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.OrdinateDimension),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Ordinate Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimordinate"
                    };

                    var annoButtonCenLine = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_CenLine_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Center Line",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._centerline"
                    };

                    var annoButtonCenMark = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_CenMark_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Reassociate",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._centermark"
                    };

                    var annoButtonDimJog = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimJog_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Jogline",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimjogline"
                    };

                    var annoButtonDimBaseline = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimBaseLine_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Baseline Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimbaseline"
                    };

                    var annoButtonDimContinue = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimContinue_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Continue Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimcontinue"
                    };

                    var annoButtonDimUpdate = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimUpdate_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Update Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._-dimstyle _apply"
                    };

                    var annoButtonDimSpace = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Dimspace_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimspace",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimspace"
                    };

                    var annoButtonDimVEdit = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimValueEdit_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Value Edit",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimvalueedit"
                    };

                    var annoButtonDimTEdit = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimTextEdit_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Text Edit",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimtedit"
                    };

                    var annoButtonDimflipArrow = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimFlipArrow_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Flip Dimension Arrow",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._aidimfliparrow"
                    };

                    var annoButtonDimBreak = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimBreak_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Break Dimension",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimbreak"
                    };

                    var annoButtonDimExtLineOff = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimRemoveExt),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Remove Extension Lines",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_DimRemoveExtLines"
                    };

                    var annoButtonDimDimLineOff = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimRemoveDim),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Remvoe Dim Lines",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_DimRemoveDimLines"
                    };

                    var annoButtonDimArrowsOff = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimRemoveArrow),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Remove Dimension Arrows",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_DimRemoveArrows"
                    };

                    var annoButtonDimReasso = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimReasso_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Reassociate",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimreassociate"
                    };

                    var annoButtonDimDisasso = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimDisasso_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Disassociate",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._dimdisassociate"
                    };

                    var annoButtonDimInspect = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DimInspect_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dimension Inspection",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._diminspect"
                    };

                    var annoButtonAvcNum = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Numbering_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Numbering",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._AVCNum"
                    };

                    var annoButtonAvcLay = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Lay_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Lay",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Lay"
                    };

                    var annoButtonAvcExplode = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Explode_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Explode",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._TNT"
                    };

                    var annoButtonAvcSawTable = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Saw_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Saw Table",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._Saw"
                    };

                    var annoButtonDimPrec4 = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimPrec4),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Set Dimension Precision to 1/16",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._aidimprec 4"
                    };

                    var annoButtonDimPrec5 = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimPrec5),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Set Dimension Precision to 1/32",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._aidimprec 5"
                    };

                    var annoButtonDimPrec6 = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.DimPrec6),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Set Dimension Precision to 1/64",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._aidimprec 6"
                    };
               
                    var annoButtonQLeader = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_QLeader_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Quick Leader",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._QLeader"
                    };

                    var annoButtonMLeader = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MLeader_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Multi Leader",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._MLeader"
                    };

                    var annoButtonWipeout = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Wipeout_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Wipeout",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._wipeout"
                    };

                    var annoButtonRevcloud = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_RevCloud_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Revcloud",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._revcloud"
                    };

                    var annoButtonMLeaderAlign = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MLeaderAlign_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Align Multileaders",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._mleaderalign"
                    };

                    var annoButtonMLeaderCollect = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MLeaderCollect_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Collect Multileaders",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._mleadercollect"
                    };

                    var annoButtonAvcUpdate = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_LeaderUpdate_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Update Smartleaders",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._AVCUpdate"
                    };

                    //Add Buttons To Anno Panel
                    var annoPanelRow1 = new RibbonRowPanel();
                    annoPanelRow1.Items.Add(annoButtonBaseView);
                    annoPanelRow1.Items.Add(annoButtonProjectView);
                    annoPanelRow1.Items.Add(annoButtonSectionView);
                    annoPanelRow1.Items.Add(annoButtonDetailView);
                    annoPanelRow1.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow1.Items.Add(annoButtonDimLinear);
                    annoPanelRow1.Items.Add(annoButtonDimAligned);
                    annoPanelRow1.Items.Add(annoButtonDimAngular);
                    annoPanelRow1.Items.Add(annoButtonDimDiam);
                    annoPanelRow1.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow1.Items.Add(annoButtonDimArc);
                    annoPanelRow1.Items.Add(annoButtonDimJogged);
                    annoPanelRow1.Items.Add(annoButtonDimOrdinate);
                    annoPanelRow1.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow1.Items.Add(annoButtonCenLine);
                    annoPanelRow1.Items.Add(annoButtonCenMark);
                    annoPanelRow1.Items.Add(annoButtonDimJog);

                    var annoPanelRow2 = new RibbonRowPanel();
                    annoPanelRow2.Items.Add(annoButtonQLeader);
                    annoPanelRow2.Items.Add(annoButtonMLeader);
                    annoPanelRow2.Items.Add(annoButtonWipeout);
                    annoPanelRow2.Items.Add(annoButtonRevcloud);
                    annoPanelRow2.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow2.Items.Add(annoButtonDimVEdit);
                    annoPanelRow2.Items.Add(annoButtonDimTEdit);
                    annoPanelRow2.Items.Add(annoButtonDimflipArrow);
                    annoPanelRow2.Items.Add(annoButtonDimBreak);
                    annoPanelRow2.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow2.Items.Add(annoButtonDimExtLineOff);
                    annoPanelRow2.Items.Add(annoButtonDimDimLineOff);
                    annoPanelRow2.Items.Add(annoButtonDimArrowsOff);
                    annoPanelRow2.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow2.Items.Add(annoButtonDimReasso);
                    annoPanelRow2.Items.Add(annoButtonDimDisasso);
                    annoPanelRow2.Items.Add(annoButtonDimInspect);

                    var annoPanelRow3 = new RibbonRowPanel();
                    annoPanelRow3.Items.Add(annoButtonAvcNum);
                    annoPanelRow3.Items.Add(annoButtonAvcLay);
                    annoPanelRow3.Items.Add(annoButtonAvcExplode);
                    annoPanelRow3.Items.Add(annoButtonAvcSawTable);
                    annoPanelRow3.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow3.Items.Add(annoButtonDimBaseline);
                    annoPanelRow3.Items.Add(annoButtonDimContinue);
                    annoPanelRow3.Items.Add(annoButtonDimUpdate);
                    annoPanelRow3.Items.Add(annoButtonDimSpace);                  
                    annoPanelRow3.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow3.Items.Add(annoButtonDimPrec4);
                    annoPanelRow3.Items.Add(annoButtonDimPrec5);
                    annoPanelRow3.Items.Add(annoButtonDimPrec6);
                    annoPanelRow3.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    annoPanelRow3.Items.Add(annoButtonMLeaderAlign);
                    annoPanelRow3.Items.Add(annoButtonMLeaderCollect);
                    annoPanelRow3.Items.Add(annoButtonAvcUpdate);

                    annotationPanel.Items.Add(annoPanelRow1);
                    annotationPanel.Items.Add(new RibbonRowBreak());
                    annotationPanel.Items.Add(annoPanelRow2);
                    annotationPanel.Items.Add(new RibbonRowBreak());
                    annotationPanel.Items.Add(annoPanelRow3);

                    #endregion

                    #region Inspect Panel Contents

                    //----Inspect Panel----//
                    var inspectButtonSumLength = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SumLength_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Sum Length",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._sumlength"
                    };

                    var inspectButtonSumArea = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SumArea_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Sum Area",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._sumarea"
                    };

                    var inspectButtonMeasurDist= new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MeasureDist_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Measure Distance",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._measuregeom _distance"
                    };

                    var inspectButtonMeasurRad = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MeasureRad_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Measure Radius",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._measuregeom _radius"
                    };

                    var inspectButtonMeasurAngle = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MeasureAngle_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Measure Angle",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._measuregeom _angle"
                    };

                    var inspectButtonMeasurVol = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_MeasureVol_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Measure Volume",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._measuregeom _volume"
                    };

                    var inspectButtonSolSize = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SolSize_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Solid Size",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._solsize"
                    };

                    var inspectButtonSweepSize = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SweepSize_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Solid Size",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._sweepsize"
                    };

                    var inspectButtonSelNoName = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectNoName_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Select No-Name",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._snn"
                    };

                    var inspectButtonSelSame = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SelectSame_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Select Same",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._sso"
                    };

                    var inspectButtonCheckSpell = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_SpellCheck_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Check Spelling",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._spell"
                    };

                    var inspectButtonFind = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Find_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Find",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._find"
                    };

                    var inspectButtonNcPrepare = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_NCPrepare_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "NC Prepare",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._NCP"
                    };

                    var inspectButtonDimOverall = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_OverallDims_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dim Overall",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._DimOverall"
                    };

                    var inspectButtonAvcFlat = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_Flat_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Flatten",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._FLT"
                    };

                    var inspectButtonOutsideLoop = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_OutsideLoop_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Outside Loop",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._OSL"
                    };

                    var inspectButtonInsideLoop = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_InsideLoop_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Inside Corner",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._IC"
                    };

                    var inspectButtonDadoLoop = new RibbonButton
                    {
                        ShowText = false,
                        ShowImage = true,
                        Image = ImageHandler.GetBitmap(Resources.CPack_DadoLoop_S),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        ToolTip = "Dado Loop",
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "._DDL"
                    };

                    var inspectPanelRow1 = new RibbonRowPanel();
                    inspectPanelRow1.Items.Add(inspectButtonSumLength);
                    inspectPanelRow1.Items.Add(inspectButtonSumArea);
                    inspectPanelRow1.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    inspectPanelRow1.Items.Add(inspectButtonMeasurDist);
                    inspectPanelRow1.Items.Add(inspectButtonMeasurRad);
                    inspectPanelRow1.Items.Add(inspectButtonMeasurAngle);
                    inspectPanelRow1.Items.Add(inspectButtonMeasurVol);

                    var inspectPanelRow2 = new RibbonRowPanel();
                    inspectPanelRow2.Items.Add(inspectButtonSolSize);
                    inspectPanelRow2.Items.Add(inspectButtonSweepSize);
                    inspectPanelRow2.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    inspectPanelRow2.Items.Add(inspectButtonSelNoName);
                    inspectPanelRow2.Items.Add(inspectButtonSelSame);
                    inspectPanelRow2.Items.Add(inspectButtonCheckSpell);
                    inspectPanelRow2.Items.Add(inspectButtonFind);

                    var inspectPanelRow3 = new RibbonRowPanel();
                    inspectPanelRow3.Items.Add(inspectButtonNcPrepare);
                    inspectPanelRow3.Items.Add(inspectButtonDimOverall);
                    inspectPanelRow3.Items.Add(new RibbonSeparator { SeparatorStyle = RibbonSeparatorStyle.Line });
                    inspectPanelRow3.Items.Add(inspectButtonAvcFlat);
                    inspectPanelRow3.Items.Add(inspectButtonOutsideLoop);
                    inspectPanelRow3.Items.Add(inspectButtonInsideLoop);
                    inspectPanelRow3.Items.Add(inspectButtonDadoLoop);

                    inspectPanel.Items.Add(inspectPanelRow1);
                    inspectPanel.Items.Add(new RibbonRowBreak());
                    inspectPanel.Items.Add(inspectPanelRow2);
                    inspectPanel.Items.Add(new RibbonRowBreak());
                    inspectPanel.Items.Add(inspectPanelRow3);

                    #endregion

                    #region Cleanup Panel Contents

                    //----Cleanup Panel----//

                    //Create Cleanup Button
                    var cPackCleanButton = new RibbonButton
                    {
                        Text = "Cleanup",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.Clean_CleanDrawing_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_CleanupDWG",
                        ToolTip = "Cleanup DWG",
                        Id = "CPack_CleanupDWG"
                    };

                    //Create CleanSolidsButton
                    var cPackCleanSolidsButton = new RibbonButton
                    {
                        Text = "Clean\nSolids",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_CleanSolids_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_CleanSolids",
                        ToolTip = "Clean DWG Solid Bodies",
                        Id = "CPack_CleanSolids"
                    };

                    //Create Purge Button
                    var cPackPurgeButton = new RibbonButton
                    {
                        Text = "Purge",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Purge_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_Purge",
                        ToolTip = "Purge",
                        Id = "CPack_Purge"
                    };


                    //Create Audit Button
                    var cPackAuditButton = new RibbonButton
                    {
                        Text = "Audit",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Audit_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_Audit",
                        ToolTip = "Audit",
                        Id = "CPack_Audit"
                    };

                    //Create Isolines Button
                    var cPackIsolinesButton = new RibbonButton
                    {
                        Text = "Fix\nIsolines",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Isolines_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_IsolineFix",
                        ToolTip = "Fix Isolines",
                        Id = "CPack_Isolines"
                    };

                    //Fix Lineweights Button
                    var cPackLineweightButton = new RibbonButton
                    {
                        Text = "Fix\nLineweights",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Lineweights_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_LineweightFix",
                        ToolTip = "Fix Lineweights",
                        Id = "CPack_Lineweights"
                    };

                    //Prepare Viewports Button
                    var cPackViewportsButton = new RibbonButton
                    {
                        Text = "Fix\nViewports",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Viewports_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_ViewportPreparation",
                        ToolTip = "Prep Viewports",
                        Id = "CPack_Viewports"
                    };

                    var cPackCleanupDropDownButton = new RibbonSplitButton
                    {
                        Text = "Clean\nDrawing",
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image,
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large
                    };

                    cPackCleanupDropDownButton.Items.Add(cPackCleanButton);
                    cPackCleanupDropDownButton.Items.Add(cPackPurgeButton);
                    cPackCleanupDropDownButton.Items.Add(cPackAuditButton);
                    cPackCleanupDropDownButton.Items.Add(cPackCleanSolidsButton);
                    cPackCleanupDropDownButton.Items.Add(cPackLineweightButton);
                    cPackCleanupDropDownButton.Items.Add(cPackIsolinesButton);
                    cPackCleanupDropDownButton.Items.Add(cPackViewportsButton);

                    //Create Select2DButton
                    var cPackCleanSelect2DButton = new RibbonButton
                    {
                        Text = "Select\n2D Elements",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_Select2D_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_Select2DElements"
                    };

                    //Create SelectAnnoButton
                    var cPackCleanSelectAnnoButton = new RibbonButton
                    {
                        Text = "Select\nAnnotations",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_SelectAnno_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_SelectAnnoElements"
                    };

                    //Create Hatch Select Button
                    var cPackCleanSelectHatchButton = new RibbonButton
                    {
                        Text = "Select\nHatches",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.SelectHatches),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_SelectHatchElements"
                    };

                    //Create SelectInsertButton
                    var cPackCleanSelectInsertButton = new RibbonButton
                    {
                        Text = "Select\nBlocks",
                        ShowText = true,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_SelectInsert_L),
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_SelectBlockElements"
                    };

                    // Create Selection Drop Down Button
                    var cPackCleanSelectDropDownButton = new RibbonSplitButton
                    {
                        Text = "Select\nElements",
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image,
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large
                    };

                    cPackCleanSelectDropDownButton.Items.Add(cPackCleanSelect2DButton);
                    cPackCleanSelectDropDownButton.Items.Add(cPackCleanSelectAnnoButton);
                    cPackCleanSelectDropDownButton.Items.Add(cPackCleanSelectHatchButton);
                    cPackCleanSelectDropDownButton.Items.Add(cPackCleanSelectInsertButton);


                    //Prepare DeleteOtherLayouts Button
                    var cPackDelOtherLaysButton = new RibbonButton
                    {
                        Text = "Delete Other Layouts",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_DeleteOtherLayouts_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_DeleteOtherLayouts",
                        ToolTip = "Delete Other Layouts That Are Not Current",
                        Id = "CPack_DelOtherLayouts"
                    };

                    //Prepare DeleteOtherLayouts Button
                    var cPackDelAllLaysButton = new RibbonButton
                    {
                        Text = "Delete All Layouts",
                        ShowText = false,
                        ShowImage = true,
                        LargeImage = ImageHandler.GetBitmap(Resources.CPack_DeleteAllLayout_L),
                        Orientation = Orientation.Horizontal,
                        Size = RibbonItemSize.Standard,
                        CommandHandler = new RibbonButtonCommandHandler(),
                        CommandParameter = "CPack_DeleteAllLayouts",
                        ToolTip = "Delete All Layout Tabs",
                        Id = "CPack_DelAllLayouts"
                    };

                    var cPackCleanDelLayoutsButton = new RibbonSplitButton
                    {
                        Text = "Delete\nLayouts",
                        SynchronizeOption = RibbonListButton.RibbonListButtonSynchronizeOption.Image,
                        ShowText = true,
                        Orientation = Orientation.Vertical,
                        Size = RibbonItemSize.Large
                    };

                    cPackCleanDelLayoutsButton.Items.Add(cPackDelOtherLaysButton);
                    cPackCleanDelLayoutsButton.Items.Add(cPackDelAllLaysButton);

                    //Add Buttons to Cleanup Panel
                    var cleanupPanelRow1 = new RibbonRowPanel {IsTopJustified = true};
                    cleanupPanelRow1.Items.Add(cPackCleanSelectDropDownButton);

                    var cleanupPanelRow2 = new RibbonRowPanel {IsTopJustified = true};
                    cleanupPanelRow2.Items.Add(cPackCleanupDropDownButton);

                    var cleanupPanelRow3 = new RibbonRowPanel {IsTopJustified = true};
                    cleanupPanelRow3.Items.Add(cPackCleanDelLayoutsButton);

                    //Add Rows To Cleanup Panel
                    cleanupPanel.Items.Add(cleanupPanelRow1);
                    cleanupPanel.Items.Add(cleanupPanelRow2);
                    cleanupPanel.Items.Add(cleanupPanelRow3);

                    #endregion

                    //Set CadPack Tab Active
                    rTab.IsActive = true;
                }
            }

            catch (Exception ex)
            {
                var ed = Application.DocumentManager.MdiActiveDocument.Editor;
                ed.WriteMessage("\n** Error: " + ex.Message + " ** ");
            }
        }

        private static void CreateMatButton(IEnumerable<Material> matList, RibbonListButton spltBtn)
        {
            foreach (var lyr in matList)
            {
                var cmdString = "._-layer _make " + lyr.Name + "\n_color " + lyr.Color + "\n" + lyr.Name + "\n\n_laycur";
                var imageName = lyr.Name;
                imageName =
                    imageName.Replace("-", "_").Replace("(", "_").Replace(")", "_").Replace(" ", "_").Replace(".", "_");

                Debug.WriteLine(imageName);

                var bmp = (Bitmap) Resources.ResourceManager.GetObject(imageName);

                var matBtn = new RibbonButton
                {
                    Text = lyr.Name,
                    ShowText = true,
                    ShowImage = true,
                    Orientation = Orientation.Vertical,
                    Size = RibbonItemSize.Large,
                    CommandHandler = new RibbonButtonCommandHandler(),
                    CommandParameter = cmdString,
                    ToolTip = "Set Layer To" + lyr.Name,
                    LargeImage = ImageHandler.GetBitmap(bmp ?? Resources.TestButton_Mid)
                };


                spltBtn.Items.Add(matBtn);
            }
        }
    }


    //RibbonButton Command Handler
    public class RibbonButtonCommandHandler : ICommand
    {
        public bool CanExecute(object parameter)

        {
            return true; //return true means the button always enabled
        }


        public event EventHandler CanExecuteChanged;


        public void Execute(object parameter)

        {
            var cmd = parameter as RibbonCommandItem;

            var dwg = Application.DocumentManager.MdiActiveDocument;

            if (cmd != null)
                dwg.SendStringToExecute("\x03\x03" + (string) cmd.CommandParameter + " ", true, false, true);
        }
    }

    //Images Handler
    public class ImageHandler
    {
        public static BitmapImage GetBitmap(Bitmap image)
        {
            var stream = new MemoryStream();
            image.Save(stream, ImageFormat.Png);
            var bmp = new BitmapImage();
            bmp.BeginInit();
            bmp.StreamSource = stream;
            bmp.EndInit();

            return bmp;
        }
    }

    #endregion
}
