using AutoMapper;
using Grand.Infrastructure.Mapper;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace LocalDemo.Tests;

[TestClass]
public class MappingDepthTests
{
    public class Node
    {
        public int Value { get; set; }
        public Node? Next { get; set; }
    }

    public class NodeModel
    {
        public int Value { get; set; }
        public NodeModel? Next { get; set; }
    }

    public class DiscoveredProfile : Profile
    {
        public DiscoveredProfile() => CreateMap<Node, NodeModel>();
    }

    private static Node Chain(int count)
    {
        var root = new Node();
        var current = root;
        for (var index = 1; index < count; index++)
        {
            current.Next = new Node { Value = index };
            current = current.Next;
        }
        return root;
    }

    private static int Count(NodeModel? value)
    {
        var count = 0;
        while (value != null)
        {
            Assert.AreEqual(count, value.Value);
            Assert.IsTrue(++count <= AutoMapperConfig.MaximumMappingDepth);
            value = value.Next;
        }
        return count;
    }

    [TestMethod]
    public void ADeepDiscoveredProfileIsBoundedWithoutTerminatingTheProcess()
    {
        var mapper = AutoMapperConfig.CreateConfiguration(config => config.AddProfile<DiscoveredProfile>()).CreateMapper();
        Assert.AreEqual(AutoMapperConfig.MaximumMappingDepth, Count(mapper.Map<NodeModel>(Chain(30000))));
    }

    [TestMethod]
    public void OrdinaryGraphsAndMappingOntoAnExistingObjectRetainTheirValues()
    {
        var mapper = AutoMapperConfig.CreateConfiguration(config => config.CreateMap<Node, NodeModel>()).CreateMapper();
        var existing = new NodeModel { Value = -1 };
        Assert.AreSame(existing, mapper.Map(Chain(4), existing));
        Assert.AreEqual(4, Count(existing));
        Assert.IsNull(mapper.Map<NodeModel>((Node?)null));
    }

    [TestMethod]
    public void EachCollectionItemHasItsOwnDepthBudget()
    {
        var mapper = AutoMapperConfig.CreateConfiguration(config => config.AddProfile<DiscoveredProfile>()).CreateMapper();
        var result = mapper.Map<NodeModel[]>(new[] { Chain(30000), Chain(30000), Chain(30000) });
        CollectionAssert.AreEqual(new[] { 32, 32, 32 }, result.Select(Count).ToArray());
    }

    [TestMethod]
    public void AnExplicitSmallerDepthIsPreserved()
    {
        var mapper = AutoMapperConfig.CreateConfiguration(config => config.CreateMap<Node, NodeModel>().MaxDepth(3)).CreateMapper();
        Assert.AreEqual(3, Count(mapper.Map<NodeModel>(Chain(30000))));
    }

    [TestMethod]
    public void AnExplicitLargeDepthCannotDisableTheApplicationBound()
    {
        var mapper = AutoMapperConfig.CreateConfiguration(config => config.CreateMap<Node, NodeModel>().MaxDepth(1000)).CreateMapper();
        Assert.AreEqual(AutoMapperConfig.MaximumMappingDepth, Count(mapper.Map<NodeModel>(Chain(30000))));
    }
}
