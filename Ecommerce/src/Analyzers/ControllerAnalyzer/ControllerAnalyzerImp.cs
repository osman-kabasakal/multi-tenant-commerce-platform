using System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;
using System.Reflection.Emit;
using System.Text.RegularExpressions;
using System.Reflection.Emit;

namespace ControllerAnalyzer;

public class ControllerAnalyzerImp
{
    public class ActionInfo
    {
        public string ActionName { get; set; }
        public string ControllerName { get; set; }
        public Type DeclaredReturnType { get; set; }
        public Type ActualModelType { get; set; }
        public bool ReturnsView { get; set; }
        public bool ReturnsJson { get; set; }
        public bool IsAsync { get; set; }
        public Type UnderlyingGenericType { get; set; }
        public ActionResultType ResultType { get; set; }
        public IDictionary<string, Type> GenericTypeArguments { get; set; }
    }

    public enum ActionResultType
    {
        Unknown,
        View,
        Json,
        File,
        Redirect,
        StatusCode,
        Custom,
        ActionResult,
        OkResult,
        BadRequestResult,
        NotFoundResult
    }

    private readonly Dictionary<string, ActionResultType> _knownResultTypes = new()
    {
        { "ViewResult", ActionResultType.View },
        { "JsonResult", ActionResultType.Json },
        { "FileResult", ActionResultType.File },
        { "RedirectResult", ActionResultType.Redirect },
        { "StatusCodeResult", ActionResultType.StatusCode }
    };

    public IEnumerable<ActionInfo> AnalyzeControllers(Assembly assembly)
    {
        var controllerTypes = assembly.GetTypes()
            .Where(type => !type.IsAbstract && typeof(ControllerBase).IsAssignableFrom(type));

        var results = new List<ActionInfo>();

        foreach (var controllerType in controllerTypes)
        {
            var actions = controllerType.GetMethods(BindingFlags.Public | BindingFlags.Instance)
                .Where(method => IsAction(method));

            foreach (var action in actions)
            {
                var actionInfo = AnalyzeAction(action, controllerType);
                if (actionInfo != null)
                {
                    results.Add(actionInfo);
                }
            }
        }

        return results;
    }

    private bool IsAction(MethodInfo method)
    {
        if (method.DeclaringType == typeof(object))
            return false;

        if (method.GetCustomAttribute<NonActionAttribute>() != null)
            return false;

        return true;
    }

    private ActionInfo AnalyzeAction(MethodInfo action, Type controllerType)
    {
        var actionInfo = new ActionInfo
        {
            ActionName = action.Name,
            ControllerName = controllerType.Name,
            DeclaredReturnType = action.ReturnType,
            GenericTypeArguments = new Dictionary<string, Type>(),
            IsAsync = IsAsyncMethod(action)
        };

        // Generic tip analizi
        AnalyzeGenericTypes(action, actionInfo);

        // IL kod analizi
        AnalyzeILCode(action, actionInfo);

        // Action result tip analizi
        AnalyzeActionResultType(actionInfo);

        return actionInfo;
    }

    private void AnalyzeGenericTypes(MethodInfo action, ActionInfo actionInfo)
    {
        var returnType = actionInfo.DeclaredReturnType;

        if (returnType.IsGenericType)
        {
            actionInfo.UnderlyingGenericType = returnType.GetGenericTypeDefinition();
            
            var genericArgs = returnType.GetGenericArguments();
            
            // Async method analizi (Task<T> veya ValueTask<T>)
            if (actionInfo.IsAsync && genericArgs.Length > 0)
            {
                var taskResultType = genericArgs[0];
                
                // ActionResult<T> veya JsonResult<T> gibi wrapper'ları kontrol et
                if (taskResultType.IsGenericType && 
                    (typeof(ActionResult<>).IsAssignableFrom(taskResultType.GetGenericTypeDefinition()) ||
                     typeof(JsonResult).IsAssignableFrom(taskResultType.GetGenericTypeDefinition())))
                {
                    var wrapperGenericArgs = taskResultType.GetGenericArguments();
                    if (wrapperGenericArgs.Length > 0)
                    {
                        actionInfo.ActualModelType = wrapperGenericArgs[0];
                    }
                }
                // IActionResult implementasyonlarını kontrol et
                else if (typeof(IActionResult).IsAssignableFrom(taskResultType))
                {
                    // IL kodundan method içindeki return ifadelerini analiz et
                    var methodBody = action.GetMethodBody();
                    if (methodBody != null)
                    {
                        // Return ifadelerindeki model tiplerini bul
                        foreach (var localVar in methodBody.LocalVariables)
                        {
                            if (typeof(ViewResult).IsAssignableFrom(localVar.LocalType) ||
                                typeof(JsonResult).IsAssignableFrom(localVar.LocalType))
                            {
                                actionInfo.ResultType = localVar.LocalType == typeof(ViewResult) ? 
                                    ActionResultType.View : ActionResultType.Json;
                                break;
                            }
                        }
                    }
                    actionInfo.ActualModelType = taskResultType;
                }
                else
                {
                    actionInfo.ActualModelType = taskResultType;
                }
            }

            // Generic argümanları kaydet
            for (int i = 0; i < genericArgs.Length; i++)
            {
                var paramName = genericArgs[i].Name;
                actionInfo.GenericTypeArguments[paramName] = genericArgs[i];
            }
        }
    }

    private bool IsAsyncMethod(MethodInfo method)
    {
        return method.ReturnType.IsGenericType &&
               (method.ReturnType.GetGenericTypeDefinition() == typeof(Task<>) ||
                method.ReturnType.GetGenericTypeDefinition() == typeof(ValueTask<>)) ||
               method.ReturnType == typeof(Task) ||
               method.ReturnType == typeof(ValueTask);
    }

    public class ILInstruction
    {
        public OpCode OpCode { get; set; }
        public object Operand { get; set; }
        public byte[] IL { get; set; }
        public int Offset { get; set; }
    }

    private void AnalyzeILCode(MethodInfo action, ActionInfo actionInfo)
    {
        try
        {
            var methodBody = action.GetMethodBody();
            if (methodBody == null) return;

            var ilBytes = methodBody.GetILAsByteArray();
            if (ilBytes == null) return;

            var instructions = ReadILInstructions(ilBytes, action.Module);

            foreach (var instruction in instructions)
            {
                if (instruction.OpCode == OpCodes.Call || instruction.OpCode == OpCodes.Callvirt)
                {
                    var methodRef = instruction.Operand as MethodInfo;
                    if (methodRef != null)
                    {
                        AnalyzeMethodCall(methodRef, actionInfo);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error analyzing IL code for action {action.Name}: {ex.Message}");
        }
    }

    private IEnumerable<ILInstruction> ReadILInstructions(byte[] il, Module module)
    {
        var instructions = new List<ILInstruction>();
        int position = 0;

        while (position < il.Length)
        {
            var instruction = new ILInstruction
            {
                IL = il,
                Offset = position
            };

            // Read OpCode
            var op = il[position++];
            if (op == 0xFE)
            {
                op = il[position++];
                instruction.OpCode = GetTwoByteOpCode(op);
            }
            else
            {
                instruction.OpCode = GetOneByteOpCode(op);
            }

            // Read Operand
            switch (instruction.OpCode.OperandType)
            {
                case OperandType.InlineMethod:
                    var methodToken = BitConverter.ToInt32(il, position);
                    try
                    {
                        instruction.Operand = module.ResolveMethod(methodToken);
                    }
                    catch
                    {
                        instruction.Operand = null;
                    }
                    position += 4;
                    break;

                case OperandType.InlineI:
                case OperandType.InlineBrTarget:
                case OperandType.InlineSig:
                case OperandType.InlineField:
                case OperandType.InlineType:
                case OperandType.InlineTok:
                    position += 4;
                    break;

                case OperandType.InlineString:
                    position += 4;
                    break;

                case OperandType.ShortInlineI:
                case OperandType.ShortInlineBrTarget:
                    position += 1;
                    break;

                case OperandType.InlineSwitch:
                    var targets = BitConverter.ToInt32(il, position);
                    position += 4 + targets * 4;
                    break;

                case OperandType.InlineVar:
                    position += 2;
                    break;

                case OperandType.ShortInlineVar:
                    position += 1;
                    break;

                case OperandType.InlineI8:
                case OperandType.InlineR:
                    position += 8;
                    break;
            }

            instructions.Add(instruction);
        }

        return instructions;
    }

    private static OpCode GetOneByteOpCode(byte op)
    {
        switch (op)
        {
            case 0x28: return OpCodes.Call;
            case 0x6F: return OpCodes.Callvirt;
            // Diğer OpCode'ları buraya ekleyebilirsiniz
            default: return OpCodes.Nop;
        }
    }

    private static OpCode GetTwoByteOpCode(byte op)
    {
        switch (op)
        {
            // İki byte'lık OpCode'ları buraya ekleyebilirsiniz
            default: return OpCodes.Nop;
        }
    }

    private void AnalyzeMethodCall(MethodInfo methodRef, ActionInfo actionInfo)
    {
        switch (methodRef.Name)
        {
            case "View":
                actionInfo.ReturnsView = true;
                AnalyzeViewParameters(methodRef, actionInfo);
                break;

            case "Json":
                actionInfo.ReturnsJson = true;
                AnalyzeJsonParameters(methodRef, actionInfo);
                break;

            case "File":
                actionInfo.ResultType = ActionResultType.File;
                break;

            case "Redirect":
            case "RedirectToAction":
            case "RedirectToRoute":
                actionInfo.ResultType = ActionResultType.Redirect;
                break;

            case "StatusCode":
                actionInfo.ResultType = ActionResultType.StatusCode;
                break;
        }
    }

    private void AnalyzeViewParameters(MethodInfo methodRef, ActionInfo actionInfo)
    {
        var parameters = methodRef.GetParameters();
        if (parameters.Length > 0)
        {
            var modelParam = parameters.FirstOrDefault(p => p.ParameterType != typeof(string));
            if (modelParam != null)
            {
                actionInfo.ActualModelType = modelParam.ParameterType;
            }
        }
    }

    private void AnalyzeJsonParameters(MethodInfo methodRef, ActionInfo actionInfo)
    {
        var parameters = methodRef.GetParameters();
        if (parameters.Length > 0)
        {
            actionInfo.ActualModelType = parameters[0].ParameterType;
        }
    }

    private void AnalyzeActionResultType(ActionInfo actionInfo)
    {
        var returnType = actionInfo.DeclaredReturnType;

        // Async method ise içteki tipi al
        if (returnType.IsGenericType && 
            (typeof(Task<>).IsAssignableFrom(returnType.GetGenericTypeDefinition()) ||
             typeof(ValueTask<>).IsAssignableFrom(returnType.GetGenericTypeDefinition())))
        {
            returnType = returnType.GetGenericArguments()[0];
        }

        // ActionResult<T> gibi generic wrapper'ları kontrol et
        if (returnType.IsGenericType && 
            typeof(ActionResult<>).IsAssignableFrom(returnType.GetGenericTypeDefinition()))
        {
            actionInfo.ResultType = ActionResultType.ActionResult;
            actionInfo.ActualModelType = returnType.GetGenericArguments()[0];
            return;
        }

        // Bilinen result tiplerini kontrol et
        if (typeof(ViewResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.View;
        else if (typeof(JsonResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.Json;
        else if (typeof(FileResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.File;
        else if (typeof(RedirectResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.Redirect;
        else if (typeof(StatusCodeResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.StatusCode;
        else if (typeof(OkResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.OkResult;
        else if (typeof(BadRequestResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.BadRequestResult;
        else if (typeof(NotFoundResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.NotFoundResult;
        else if (typeof(IActionResult).IsAssignableFrom(returnType))
            actionInfo.ResultType = ActionResultType.Custom;
        else
            actionInfo.ResultType = ActionResultType.Unknown;
    }

    public Type GetViewModelType(MethodInfo action)
    {
        var actionInfo = AnalyzeAction(action, action.DeclaringType);
        return actionInfo?.ActualModelType;
    }
}